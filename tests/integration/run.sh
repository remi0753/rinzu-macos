#!/bin/sh
set -eu

case "${1:-all}:$#" in
    all:0 | all:1 | runner:1 | aot:1 | acquisitions:1 | appkit:1 | examples:1 | interrupt:1 | distribution:1 | distribution-candidate:1) suite=${1:-all} ;;
    *)
        printf 'Usage: %s [runner|aot|acquisitions|appkit|examples|interrupt|distribution|distribution-candidate|all]\n' "$0" >&2
        exit 2
        ;;
esac

directory=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
root=$(CDPATH='' cd -- "$directory/../.." && pwd -P)
rinzu=$(command -v rinzu) || {
    printf 'Put rinzu on PATH.\n' >&2
    exit 1
}
rinzu=$(realpath "$rinzu")
if [ -L "$root/build" ] || [ -L "$root/build/tests" ]; then
    printf 'Test outputs require a local build/tests directory.\n' >&2
    exit 1
fi
mkdir -p "$root/build/tests"
build_dir="$root/build/tests/integration"
mkdir "$build_dir"
trap 'rm -rf -- "$build_dir"' EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

export TMPDIR="$build_dir"
export RINZU_CACHE_DIR="$build_dir/cache"
export CLANG_MODULE_CACHE_PATH="$build_dir/clang-cache"
export ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
export UBSAN_OPTIONS=halt_on_error=1
appkit_input="$build_dir/appkit-input.dylib"

if [ -n "${RINZU_TOOLCHAIN_ROOT:-}" ]; then
    resources=$(realpath "$RINZU_TOOLCHAIN_ROOT")
    export RINZU_TOOLCHAIN_ROOT="$resources"
else
    unset RINZU_TOOLCHAIN_ROOT
    resources=$(dirname -- "$rinzu")/../share/rinzu
fi

xcrun clang -std=c11 -Wall -Wextra -Werror "$root/tests/native/timeout.c" -o "$build_dir/timeout"

run_timed() {
    "$build_dir/timeout" "$@"
}

rinzu_cli() {
    run_timed 180 "$rinzu" "$@"
}

expect_output() {
    if ! grep -Fq -- "$1" "$2"; then
        printf 'Missing expected output: %s\n' "$1" >&2
        cat "$2" >&2
        exit 1
    fi
}

expect_clean_cancellation() {
    if ! awk '
        BEGIN { cancelled = "2@(-|[0-9]+:[0-9]+:[0-9]+)" }
        /^RINZU_FAILURE=/ {
            if ($0 != "RINZU_FAILURE=cancelled") exit 1
            failures++
        }
        /^RINZU_DIAGNOSTICS=/ {
            if ($0 !~ ("^RINZU_DIAGNOSTICS=" cancelled "(," cancelled ")*$")) exit 1
            diagnostics++
        }
        END { if (failures != 1 || diagnostics != 1) exit 1 }
    ' "$1"; then
        printf 'Expected cancellation without cleanup failures.\n' >&2
        cat "$1" >&2
        return 1
    fi
}

expect_failure() {
    message=$1
    shift
    status=0
    run_timed 180 "$@" </dev/null >"$build_dir/failure.log" 2>&1 || status=$?
    if [ "$status" -ne 1 ]; then
        printf 'Expected exit 1, got %s: %s\n' "$status" "$*" >&2
        cat "$build_dir/failure.log" >&2
        exit 1
    fi
    expect_output "$message" "$build_dir/failure.log"
}

fixture_app() {
    mkdir -p "$1/src"
    cat >"$1/rinzu.toml" <<MANIFEST
[package]
name = "macos_fixture"
language = "0.5"

[dependencies]
"rinzu.macos" = { path = "../../../.." }
MANIFEST
}

sanitize_aot() {
    run_timed 120 xcrun clang -std=c11 -Wno-unused-label -pthread -O1 -g \
        -fsanitize=address,undefined -fno-omit-frame-pointer \
        "$1.o" "$1.runtime.c" "$resources/runtime/callback_entry.c" \
        "$resources/runtime/callback_template.S" "$resources/runtime/owner_dispatcher.c" \
        -I "$resources/include" -framework CoreFoundation -o "$2"
    for suffix in source-packages resources; do
        if [ -e "$1.$suffix" ]; then
            ln -s "$1.$suffix" "$2.$suffix"
        fi
    done
}

interrupt_policies() {
    for policy in default ignored blocked; do
        run_timed 100 "$build_dir/check-interrupt" "$policy" "$@"
    done
}

verify_interrupt() {
    app="$build_dir/interrupt"
    fixture_app "$app"
    ln "$root/tests/interrupt/main.rinzu.in" "$app/src/main.rinzu"
    run_timed 120 xcrun clang -std=c11 -Wall -Wextra -Werror "$root/tests/native/interrupt.c" -o "$build_dir/check-interrupt"

    interrupt_policies "$rinzu" run "$app"
    binary="$build_dir/interrupt-app"
    rinzu_cli build "$app" --output "$binary"
    interrupt_policies "$binary"

    mkdir "$build_dir/signed"
    rinzu_cli build "$app" --output "$build_dir/signed/app"
    cat >"$build_dir/entitlements.plist" <<'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict><key>com.apple.security.cs.disable-library-validation</key><true/></dict>
</plist>
PLIST
    run_timed 120 codesign --force --sign - --options runtime --entitlements "$build_dir/entitlements.plist" "$build_dir/signed/app"
    run_timed 120 codesign --verify --strict "$build_dir/signed/app"
    interrupt_policies "$build_dir/signed/app"

    # Building the app has already materialized the embedded runtime for a source-built Rinzu.
    if [ ! -f "$resources/runtime/callback_entry.c" ]; then
        set -- "$RINZU_CACHE_DIR"/resources/*/runtime/callback_entry.c
        if [ ! -f "$1" ]; then
            printf 'Rinzu runtime sources are missing from %s.\n' "$RINZU_CACHE_DIR" >&2
            exit 1
        fi
        resources=${1%/runtime/callback_entry.c}
    fi
    sanitize_aot "$binary" "$build_dir/interrupt-sanitized"
    interrupt_policies "$build_dir/interrupt-sanitized"

    fixture_app "$build_dir/callback"
    ln "$root/tests/app/src/"*.rinzu "$build_dir/callback/src/"
    cat >"$build_dir/callback/src/main.rinzu" <<'RINZU'
import "cases.rinzu" as cases;

async fn main() {
    try {
        await cases.runCallback();
    }
    catch errors {
        panic(f"callback fixture failed: {errors}");
    }
}
RINZU
    rinzu_cli build "$build_dir/callback" --output "$build_dir/callback-app"
    sanitize_aot "$build_dir/callback-app" "$build_dir/callback-sanitized"
    RINZU_GC_STRESS=1 run_timed 120 "$build_dir/callback-sanitized" </dev/null >"$build_dir/callback.log"
    expect_output "SOURCE:callback-ok:2:42" "$build_dir/callback.log"
    expect_output "SOURCE:closed" "$build_dir/callback.log"
    printf 'PASS:callback:managed-gc:address-and-undefined\n'
}

verify_aot() {
    outcome=$1
    shift
    rinzu_cli verify-aot "$@" </dev/null >"$build_dir/verify-aot.log" || {
        cat "$build_dir/verify-aot.log" >&2
        exit 1
    }
    expect_output "outcome=$outcome" "$build_dir/verify-aot.log"
    expect_output "resources=baseline" "$build_dir/verify-aot.log"
}

verify_settlement() (
    report="$build_dir/$1.json"
    tail -n 1 "$build_dir/$1.jsonl" >"$report"
    [ "$(plutil -extract phase raw -o - "$report")" = end ]
    index=0
    seen=''
    : >"$build_dir/$1-callback-ledger"
    while category=$(plutil -extract "categories.$index.id" raw -o - "$report" 2>/dev/null); do
        case "$category" in
            managed | task | future | pending_operation | transport | native_calls | callback_scoped | callback_in_flight | foreign_queue)
                live=$(plutil -extract "categories.$index.live" raw -o - "$report")
                [ "$live" -eq 0 ] || {
                    printf 'Resources still live after %s: %s=%s\n' "$1" "$category" "$live" >&2
                    exit 1
                }
                seen="$seen $category"
                ;;
        esac
        case "$category" in
            native_calls | callback_entries)
                count=$(plutil -extract "categories.$index.allocated" raw -o - "$report")
                printf '%s=%s\n' "$category" "$count" >>"$build_dir/$1-callback-ledger"
                ;;
        esac
        index=$((index + 1))
    done
    for category in managed task future pending_operation transport native_calls callback_scoped callback_in_flight foreign_queue; do
        case " $seen " in
            *" $category "*) ;;
            *)
                printf 'Missing resource category: %s\n' "$category" >&2
                exit 1
                ;;
        esac
    done
)

run_checked() (
    backend=$1
    expected=$2
    shift 2
    rm -f -- "$build_dir/$backend.jsonl"
    export RINZU_RESOURCE_REPORT="$build_dir/$backend.jsonl"
    export RINZU_RESOURCE_INTERVAL_MS=0
    status=0
    run_timed 120 "$@" </dev/null >"$build_dir/$backend.stdout" 2>"$build_dir/$backend.stderr" || status=$?
    if [ "$status" -ne "$expected" ] ||
        grep -Eq 'ERROR: AddressSanitizer|runtime error:|WARNING: ThreadSanitizer|MISSING POOLS' "$build_dir/$backend.stderr"; then
        printf 'Unexpected exit or runtime diagnostic from %s: %s\n' "$backend" "$*" >&2
        cat "$build_dir/$backend.stdout" "$build_dir/$backend.stderr" >&2
        exit 1
    fi
    if [ "$expected" -eq 1 ]; then
        expect_clean_cancellation "$build_dir/$backend.stderr" || exit 1
    fi
    verify_settlement "$backend"
)

compare_backends() (
    app=$1
    executable=$2
    expected_status=$3
    shift 3
    if [ ! -x "$executable" ]; then
        rinzu_cli build "$app" --output "$executable" "$@"
    fi
    run_checked jit "$expected_status" "$rinzu" run "$app" \
        --resource-report "$build_dir/jit.jsonl" --resource-interval-ms 0 "$@"
    run_checked aot "$expected_status" "$executable"
    diff -u "$build_dir/jit.stdout" "$build_dir/aot.stdout"
)

verify_runner() {
    status=0
    run_timed 1 /bin/sleep 30 >"$build_dir/timeout.log" 2>&1 || status=$?
    [ "$status" -eq 124 ]
    expect_output "Command timed out (limit 1 s):" "$build_dir/timeout.log"
    printf 'PASS:runner:timeout\n'

    source="$root/tests/runner/cancel-cleanup.rinzu"
    executable="$build_dir/cancel-cleanup"
    RINZU_TEST_CLEANUP_FAILURE=0 compare_backends "$source" "$executable" 1 -l System
    export RINZU_TEST_CLEANUP_FAILURE=1
    if run_checked jit 1 "$rinzu" run "$source" -l System \
        --resource-report "$build_dir/jit.jsonl" --resource-interval-ms 0 >"$build_dir/rejected.log" 2>&1; then
        printf 'JIT accepted a failed cancellation cleanup.\n' >&2
        exit 1
    fi
    expect_output "Expected cancellation without cleanup failures." "$build_dir/rejected.log"
    if run_checked aot 1 "$executable" >"$build_dir/rejected.log" 2>&1; then
        printf 'AOT accepted a failed cancellation cleanup.\n' >&2
        exit 1
    fi
    expect_output "Expected cancellation without cleanup failures." "$build_dir/rejected.log"
    printf 'PASS:runner:cancelled-cleanup\n'
}

source_fixture() {
    fixture_app "$build_dir/$1"
    ln "$root/tests/$1/src/"*.rinzu "$build_dir/$1/src/"
    if [ "$1" = canvas-geometry ]; then
        call='cases.run()'
    else
        call='cases.run(rinzu.process.setting("RINZU_MACOS_SCENARIO", ""))'
    fi
    cat >"$build_dir/$1/src/main.rinzu" <<RINZU
import "cases.rinzu" as cases;
import rinzu.process;

async fn main() {
    try {
        await $call;
    }
    catch errors {
        panic(f"fixture failed: {errors}");
    }
}
RINZU
}

verify_source_scenarios() {
    for name in app canvas canvas-geometry data graphics gui; do
        source_fixture "$name"
    done
    while read -r name scenario outcome; do
        case "$name:$scenario" in
            app:callback)
                RINZU_MACOS_SCENARIO="$scenario" RINZU_GC_STRESS=1 compare_backends \
                    "$build_dir/$name" "$build_dir/$name-aot" 0
                diff -u "$build_dir/jit-callback-ledger" "$build_dir/aot-callback-ledger"
                ;;
            app:cancel)
                RINZU_MACOS_SCENARIO="$scenario" compare_backends "$build_dir/$name" "$build_dir/$name-aot" 1
                RINZU_MACOS_SCENARIO="$scenario" verify_aot "$outcome" "$build_dir/$name"
                ;;
            app:*)
                RINZU_MACOS_SCENARIO="$scenario" verify_aot "$outcome" "$build_dir/$name"
                ;;
            *)
                expected=0
                if [ "$outcome" = cancelled ]; then expected=1; fi
                RINZU_MACOS_SCENARIO="$scenario" compare_backends "$build_dir/$name" "$build_dir/$name-aot" "$expected"
                ;;
        esac
        printf 'PASS:aot:%s:%s\n' "$name" "$scenario"
    done <<'CASES'
app core success
app callback success
app gpu success
app recording success
app close success
app cancel cancelled
canvas cancel cancelled
canvas-geometry retry success
data basic success
data early success
data stop success
data large success
data multi success
data cancel cancelled
graphics cancel cancelled
gui events success
gui scope success
gui early success
gui cancel cancelled
gui signal-ownership success
gui failure success
gui overflow success
gui gpu-recording success
gui gpu-submitted success
CASES
}

verify_cancelled_aot() {
    cancel_app=$1
    shift
    rinzu_cli build "$cancel_app" --output "$build_dir/cancelled-app"
    expect_failure "RINZU_FAILURE=cancelled" env RINZU_CANCEL_AFTER_POLLS=5000 "$build_dir/cancelled-app"
    expect_clean_cancellation "$build_dir/failure.log"
    for marker; do
        expect_output "$marker" "$build_dir/failure.log"
    done
    verify_aot cancelled "$cancel_app" --cancel-after-polls 5000
}

verify_return_cancellation() (
    app=$1
    native=$2
    closed=$3
    hint=$4
    binary="$app-acquisition"
    if [ ! -x "$binary" ]; then
        rinzu_cli build "$app" --output "$binary"
    fi
    source_id=$(plutil -extract sourceFiles xml1 -o - "$binary.metadata.json" | awk -F '[<>]' '
        $2 == "key" { id = $3 }
        $2 == "string" && $3 == "rinzu.macos/src/macos.rinzu" { print id }
    ')
    [ -n "$source_id" ]

    radius=16
    if [ "$native" = canvas2D ]; then
        radius=48
    fi
    # For native returns, checked() identifies the call whose value was lost to
    # cancellation. The Canvas fixture observes scope ownership before return.
    polls=$(awk -v hint="$hint" -v radius="$radius" 'BEGIN {
        print hint
        for (delta = 1; delta <= radius; delta++) {
            if (hint > delta) print hint - delta
            print hint + delta
        }
    }')
    for poll in $polls; do
        status=0
        RINZU_CANCEL_AFTER_POLLS="$poll" run_timed 8 "$binary" \
            </dev/null >"$build_dir/failure.log" 2>&1 || status=$?
        if [ "$status" -ne 1 ]; then
            continue
        fi
        if [ "$native" = canvas2D ]; then
            if ! grep -Fxq "CANVAS:scope-owned-before-return" "$build_dir/failure.log"; then
                continue
            fi
        else
            location=$(sed -n 's/^RINZU_DIAGNOSTICS=2@\([^,]*\).*/\1/p' "$build_dir/failure.log")
            IFS=: read -r file start end <<LOCATION
$location
LOCATION
            if [ "$file" != "$source_id" ]; then
                continue
            fi
            expression=$(dd if="$root/src/macos.rinzu" bs=1 skip="$start" count="$((end - start))" 2>/dev/null | tr -d '[:space:]')
            case "$expression" in
                "checked($native("* | "checked(Int($native("*) ;;
                *) continue ;;
            esac
        fi
        expect_clean_cancellation "$build_dir/failure.log"
        expect_output "$closed" "$build_dir/failure.log"
        verify_aot cancelled "$app" --cancel-after-polls "$poll"
        exit 0
    done
    printf 'Cancellation did not reach the expected acquisition in %s for %s (poll hint %s).\n' "$native" "$app" "$hint" >&2
    cat "$build_dir/failure.log" >&2
    exit 1
)

verify_acquisitions() {
    for name in data-acquire canvas-acquire graphics-acquire; do
        fixture_app "$build_dir/$name"
        ln "$root/tests/$name/src/main.rinzu" "$build_dir/$name/src/"
    done
    fixture_app "$build_dir/sheets"
    ln "$root/tests/sheets/acquisition.rinzu" "$build_dir/sheets/src/main.rinzu"
    while read -r name scenario native setting closed hint; do
        export "$setting=$scenario"
        verify_return_cancellation "$build_dir/$name" "$native" "$closed" "$hint"
        unset "$setting"
        printf 'PASS:acquisition:%s:%s\n' "$name" "$scenario"
    done <<'CASES'
data-acquire cell rawDataCell RINZU_DATA_ACQUIRE DATA:acquisition:closed 231
data-acquire stage rawDataBegin RINZU_DATA_ACQUIRE DATA:acquisition:closed 164
canvas-acquire frame rawFrameCreate RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 154
canvas-acquire canvas canvas2D RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 220
canvas-acquire wait rawFrameBegin RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 190
canvas-acquire font rawFontCreate RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 45
canvas-acquire layout rawTextCreate RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 56
canvas-acquire raster rawTextTexture RINZU_CANVAS_ACQUIRE CANVAS:acquisition:closed 65
graphics-acquire texture rawTextureCreate RINZU_GRAPHICS_ACQUIRE GRAPHICS:acquisition:closed 41
graphics-acquire sampler rawSamplerCreate RINZU_GRAPHICS_ACQUIRE GRAPHICS:acquisition:closed 42
graphics-acquire image rawTextureImage RINZU_GRAPHICS_ACQUIRE GRAPHICS:acquisition:closed 45
graphics-acquire batch rawBufferAllocate RINZU_GRAPHICS_ACQUIRE GRAPHICS:acquisition:closed 171
graphics-acquire frame rawRenderTexture RINZU_GRAPHICS_ACQUIRE GRAPHICS:acquisition:closed 283
sheets acquisition rawPanelBegin RINZU_SHEET_TEST SHEETS:closed 138
CASES
    RINZU_SHEET_TEST=cancel compare_backends "$build_dir/sheets" "$build_dir/sheets-acquisition" 1
    RINZU_SHEET_TEST=cancel verify_aot cancelled "$build_dir/sheets"
    printf 'PASS:aot:sheets:future-cancellation\n'
    fixture_app "$build_dir/document-cancel"
    ln "$root/tests/document-cancel/src/main.rinzu" "$build_dir/document-cancel/src/"
    verify_cancelled_aot "$build_dir/document-cancel" DOCUMENT:mutating DOCUMENT:undo-ready DOCUMENT:invariants-ok
    printf 'PASS:aot:document:root-cancellation\n'
}

build_appkit_input() {
    if [ ! -f "$appkit_input" ]; then
        run_timed 120 xcrun clang -dynamiclib -fobjc-arc -Wall -Wextra -Werror -framework AppKit \
            "$root/tests/native/appkit-input.m" -o "$appkit_input"
    fi
}

verify_appkit_results() {
    build_appkit_input
    fixture_app "$build_dir/binding-events"
    ln "$root/tests/binding/events.rinzu" "$build_dir/binding-events/src/main.rinzu"
    compare_backends "$build_dir/binding-events" "$build_dir/binding-app" 0 --native-object "$appkit_input"
    expect_output "BINDING:appkit-commit:coalesced-selection:closed" "$build_dir/jit.stdout"
    printf 'PASS:appkit:binding-events\n'

    fixture_app "$build_dir/sheet-results"
    ln "$root/tests/sheets/results.rinzu" "$build_dir/sheet-results/src/main.rinzu"
    mkdir "$build_dir/sheet-files"
    RINZU_SHEET_TEST_DIRECTORY="$build_dir/sheet-files" \
        compare_backends "$build_dir/sheet-results" "$build_dir/sheet-results-app" 0 --native-object "$appkit_input"
    expect_output "SHEETS:appkit-results:closed" "$build_dir/jit.stdout"
    printf 'PASS:appkit:sheet-results\n'
}

example_fixture() {
    fixture_app "$build_dir/$1"
    ln "$root/tests/examples/$1.rinzu" "$build_dir/$1/src/main.rinzu"
    ln "$root/examples/${2:-$1}/src/main.rinzu" "$build_dir/$1/src/example.rinzu"
}

verify_notepad() {
    sample="$build_dir/macos-notepad"
    example_fixture macos-notepad
    for scenario in cancel-discard save-close save-failure save-as save-as-cancel open-cancel load save-edit; do
        file="$build_dir/notepad.txt"
        printf 'Original 日本語 😀\n' >"$file"
        rm -f -- "$file.new.txt"
        RINZU_NOTEPAD_TEST="$scenario" RINZU_NOTEPAD_PATH="$file" verify_example_pair "$sample" \
            "NOTEPAD:TEST:$scenario:ok"
        printf 'PASS:example:notepad:%s\n' "$scenario"
    done
}

# Each backend gets the same initial file and an unused Save As destination.
verify_example_pair() {
    if [ ! -x "$build_dir/notepad-app" ]; then
        rinzu_cli build "$1" --output "$build_dir/notepad-app"
    fi
    run_checked jit 0 "$rinzu" run "$1" --resource-report "$build_dir/jit.jsonl" --resource-interval-ms 0
    expect_output "$2" "$build_dir/jit.stdout"
    printf 'Original 日本語 😀\n' >"$RINZU_NOTEPAD_PATH"
    rm -f -- "$RINZU_NOTEPAD_PATH.new.txt"
    run_checked aot 0 "$build_dir/notepad-app"
    diff -u "$build_dir/jit.stdout" "$build_dir/aot.stdout"
}

verify_editor() {
    example_fixture editor-model editor
    for scenario in unicode stale; do
        RINZU_EDITOR_SCENARIO="$scenario" compare_backends "$build_dir/editor-model" "$build_dir/editor-model-app" 0
        printf 'PASS:example:editor:%s\n' "$scenario"
    done

    example_fixture editor-ime editor
    build_appkit_input
    RINZU_EDITOR_IME_PATH="$build_dir/editor.txt" compare_backends "$build_dir/editor-ime" "$build_dir/editor-ime-app" 0 \
        --native-object "$appkit_input"
    printf 'PASS:example:editor:composition-close-policy\n'
}

verify_examples() {
    # Keep Rinzu's generated package files under the test build directory.
    metal="$build_dir/macos-metal"
    fixture_app "$metal"
    ln "$root/examples/macos-metal/src/main.rinzu" "$metal/src/"
    RINZU_MACOS_FRAMES=3 compare_backends "$metal" "$build_dir/macos-metal-aot" 0
    printf 'PASS:example:macos-metal\n'
    for sample in macos-widgets macos-charts macos-data-browser macos-image-viewer macos-task-list; do
        example_fixture "$sample"
        RINZU_IMAGE_PATH="$root/examples/macos-charts/assets/AppIcon.png" \
            compare_backends "$build_dir/$sample" "$build_dir/$sample-aot" 0
        printf 'PASS:example:%s\n' "$sample"
    done
    verify_editor
    verify_notepad
}

stage_archive_app() {
    mkdir -p "$2/src"
    ln "$1/src/main.rinzu" "$2/src/"
    awk '
        $0 == "\"rinzu.macos\" = { path = \"../..\" }" { removed++; next }
        { print }
        END { if (removed != 1) exit 1 }
    ' "$1/rinzu.toml" >"$2/rinzu.toml"
}

add_archive() {
    (
        cd "$1"
        rinzu_cli modules add rinzu.macos "$locator" >"$build_dir/modules-add.log"
        expect_output "added rinzu.macos (sha256:$digest)" "$build_dir/modules-add.log"
        expect_output "\"rinzu.macos\" = { archive = \"$locator\" }" rinzu.toml
        index=0
        while package=$(plutil -extract "packages.$index.name" raw -o - rinzu.modules.lock 2>/dev/null); do
            if [ "$package" = rinzu.macos ]; then
                break
            fi
            index=$((index + 1))
        done
        if [ "$package" != rinzu.macos ]; then
            printf 'SDK missing from module lock: %s\n' "$PWD/rinzu.modules.lock" >&2
            exit 1
        fi
        [ "$(plutil -extract "packages.$index.source.archive.locator" raw -o - rinzu.modules.lock)" = "$locator" ]
        [ "$(plutil -extract "packages.$index.source.archive.sha256" raw -o - rinzu.modules.lock)" = "$digest" ]
        [ -f "modules/store/sha256/$digest/package/native/src/macos.m" ]
    )
}

verify_bundle() {
    rinzu_cli bundle-verify "$1"
    (
        cd "$build_dir"
        unset RINZU_BUNDLE_DEV_ROOT RINZU_TOOLCHAIN_ROOT RINZU_CACHE_DIR
        run_timed 120 "$1/Contents/MacOS/$2" </dev/null >"$build_dir/relocated.log"
    )
    diff -u "$3" "$build_dir/relocated.log"
}

distribution_case() (
    edition=$1
    destination="$build_dir/$edition"
    apps="$destination/apps"
    export RINZU_CACHE_DIR="$destination/cache"
    mkdir -p "$apps"
    if [ "$edition" = published ]; then
        locator="https://github.com/remi0753/rinzu-macos/releases/download/v0.3.0/rinzu-macos-0.3.0.tar.gz"
        digest="da468d630a6fe075d3111d6d5d91a93e21ac52ece74bb486f27b86188d3e2223"
    else
        candidate="$destination/candidate.tar.gz"
        if [ -n "${RINZU_MACOS_TEST_ARCHIVE:-}${RINZU_MACOS_TEST_SHA256:-}" ]; then
            archive=$(realpath "${RINZU_MACOS_TEST_ARCHIVE:?set the archive path}")
            digest=${RINZU_MACOS_TEST_SHA256:?set the expected archive digest}
            ln -s "$archive" "$candidate"
        else
            COPYFILE_DISABLE=1 tar -czf "$candidate" -C "$root" rinzu.toml src native
            digest=$(shasum -a 256 "$candidate" | awk '{print $1}')
        fi
        locator="../../candidate.tar.gz"
    fi
    [ ! -e "$resources/sdk/rinzu.macos" ]

    probe="$apps/resources"
    mkdir -p "$probe/src" "$probe/assets" "$probe/data"
    ln "$root/tests/bundle/src/main.rinzu" "$probe/src/"
    ln "$root/tests/bundle/macos-app.json" "$probe/"
    ln "$root/tests/bundle/assets/日本語.txt" "$probe/assets/"
    ln "$root/tests/bundle/data/probe.txt" "$probe/data/"
    cat >"$probe/rinzu.toml" <<'MANIFEST'
[package]
name = "macos_bundle_probe"
language = "0.5"
MANIFEST
    expect_failure 'SDK package `rinzu.macos` is not a declared dependency' "$rinzu" check "$probe"
    add_archive "$probe"
    original_lock=$(shasum -a 256 "$probe/rinzu.modules.lock")
    rm -rf -- "$probe/modules"
    (cd "$probe" && rinzu_cli modules sync --offline)
    [ "$(shasum -a 256 "$probe/rinzu.modules.lock")" = "$original_lock" ]
    rinzu_cli lock "$probe"
    rinzu_cli lock "$probe" --check

    for manifest in "$root/examples/"*/rinzu.toml; do
        sample=$(dirname -- "$manifest")
        app="$apps/${sample##*/}"
        stage_archive_app "$sample" "$app"
        add_archive "$app"
        rinzu_cli check "$app"
    done
    ln "$root/examples/macos-metal/macos-app.json" "$apps/macos-metal/"

    RINZU_BUNDLE_EXPECT_APP=0 RINZU_BUNDLE_DEV_ROOT="$probe" rinzu_cli run "$probe" </dev/null >"$destination/resources.log"
    expect_output "BUNDLE:closed" "$destination/resources.log"
    RINZU_BUNDLE_DEV_ROOT="$probe" rinzu_cli bundle "$probe" --output "$destination/Resources 初回.app"
    mv "$destination/Resources 初回.app" "$destination/Resources 移設.app"
    RINZU_MACOS_FRAMES=3 rinzu_cli run "$apps/macos-metal" </dev/null >"$destination/metal.log"
    expect_output "MACOS:compute-ok" "$destination/metal.log"
    expect_output "MACOS:frames=3" "$destination/metal.log"
    expect_output "MACOS:closed" "$destination/metal.log"
    rinzu_cli bundle "$apps/macos-metal" --output "$destination/Metal 初回.app"
    mv "$destination/Metal 初回.app" "$destination/Metal 移設.app"

    rm -rf -- "$apps" "$RINZU_CACHE_DIR"
    (RINZU_BUNDLE_EXPECT_APP=1 verify_bundle "$destination/Resources 移設.app" macos_bundle_probe "$destination/resources.log")
    (RINZU_MACOS_FRAMES=3 verify_bundle "$destination/Metal 移設.app" macos_metal "$destination/metal.log")
    printf 'tampered\n' >"$destination/Resources 移設.app/Contents/Resources/app/assets/日本語.txt"
    expect_failure "inventory changed" "$rinzu" bundle-verify "$destination/Resources 移設.app"
    printf 'PASS:distribution:%s\n' "$edition"
)

verify_distribution() {
    if [ -n "${RINZU_MACOS_TEST_ARCHIVE:-}${RINZU_MACOS_TEST_SHA256:-}" ]; then
        if [ -z "${RINZU_MACOS_TEST_ARCHIVE:-}" ] || [ -z "${RINZU_MACOS_TEST_SHA256:-}" ]; then
            printf 'Set both RINZU_MACOS_TEST_ARCHIVE and RINZU_MACOS_TEST_SHA256.\n' >&2
            exit 2
        fi
    elif [ "$suite" != distribution-candidate ]; then
        distribution_case published
    fi
    distribution_case candidate
}

# Keep scenario settings local when the full launcher runs several groups.
case "$suite" in
    all | runner) (verify_runner) ;;
esac
case "$suite" in
    all | aot) (verify_source_scenarios) ;;
esac
case "$suite" in
    all | aot | acquisitions) (verify_acquisitions) ;;
esac
case "$suite" in
    all | appkit) (verify_appkit_results) ;;
esac
case "$suite" in
    all | examples) (verify_examples) ;;
esac
case "$suite" in
    all | interrupt) (verify_interrupt) ;;
esac
case "$suite" in
    all | distribution | distribution-candidate) (verify_distribution) ;;
esac
