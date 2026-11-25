#!/bin/sh
set -eu

case "${1:-all}:$#" in
    all:0 | all:1) variants="plain asan tsan" ;;
    plain:1 | asan:1 | tsan:1) variants=$1 ;;
    *)
        printf 'Usage: %s [plain|asan|tsan|all]\n' "$0" >&2
        exit 2
        ;;
esac

native_dir=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd -P)
root=$(CDPATH='' cd -- "$native_dir/../.." && pwd -P)
if [ -L "$root/build" ] || [ -L "$root/build/tests" ]; then
    printf 'Test outputs require a local build/tests directory.\n' >&2
    exit 1
fi
mkdir -p "$root/build/tests"
build_dir="$root/build/tests/native"
mkdir "$build_dir"
probe_pid=''
watchdog_pid=''

cleanup() {
    if [ -n "$probe_pid" ]; then
        kill -KILL "$probe_pid" 2>/dev/null || :
        wait "$probe_pid" 2>/dev/null || :
    fi
    if [ -n "$watchdog_pid" ]; then
        kill "$watchdog_pid" 2>/dev/null || :
        wait "$watchdog_pid" 2>/dev/null || :
    fi
    rm -rf -- "$build_dir"
}
trap cleanup EXIT
trap 'exit 129' HUP
trap 'exit 130' INT
trap 'exit 143' TERM

export TMPDIR="$build_dir"
export RINZU_CACHE_DIR="$build_dir/rinzu-cache"
export CLANG_MODULE_CACHE_PATH="$build_dir/clang-cache"
export ASAN_OPTIONS=detect_leaks=0:halt_on_error=1
export UBSAN_OPTIONS=halt_on_error=1
export TSAN_OPTIONS=halt_on_error=1

resources=${RINZU_TOOLCHAIN_ROOT:-}
if [ -z "$resources" ]; then
    unset RINZU_TOOLCHAIN_ROOT
    rinzu=$(command -v rinzu) || {
        printf 'Put rinzu on PATH or set RINZU_TOOLCHAIN_ROOT to its resource directory.\n' >&2
        exit 1
    }
    resources=$(dirname -- "$(realpath "$rinzu")")/../share/rinzu
    if [ ! -d "$resources" ]; then
        # A source build of Rinzu extracts its embedded headers into the configured cache.
        printf 'import rinzu.stdio;\nfn main() {}\n' >"$build_dir/headers.rinzu"
        "$rinzu" check "$build_dir/headers.rinzu" >/dev/null
        set -- "$RINZU_CACHE_DIR"/resources/*/include/rinzu/native_completion.h
        resources=${1%/include/rinzu/native_completion.h}
    fi
fi
if [ ! -f "$resources/include/rinzu/native_completion.h" ]; then
    printf 'Rinzu native headers are missing from %s.\n' "$resources" >&2
    exit 1
fi

build_probe() {
    case "$variant" in
        plain) set -- ;;
        asan) set -- -O1 -g -fsanitize=address,undefined -fno-omit-frame-pointer ;;
        tsan) set -- -O1 -g -fsanitize=thread ;;
    esac
    xcrun clang -std=c11 -fobjc-arc -Wall -Wextra -Werror "$@" \
        -I "$resources/include" -I "$root/native/include" "$native_dir/$name.m" \
        -framework AppKit -framework Foundation -framework Metal -framework QuartzCore \
        -framework ImageIO -framework CoreGraphics -framework CoreText \
        -framework UniformTypeIdentifiers -o "$binary"
}

# Apply the deadline to the probe executable, which runs the AppKit event loop.
run_timed() {
    "$@" >"$probe_log" 2>&1 &
    probe_pid=$!
    (
        trap - EXIT
        timer=''
        trap 'if [ -n "$timer" ]; then kill "$timer" 2>/dev/null || :; wait "$timer" 2>/dev/null || :; fi; exit 0' TERM
        sleep 55 &
        timer=$!
        wait "$timer" && kill -KILL "$probe_pid" 2>/dev/null
    ) &
    watchdog_pid=$!
    status=0
    wait "$probe_pid" || status=$?
    probe_pid=''
    kill "$watchdog_pid" 2>/dev/null || :
    wait "$watchdog_pid" 2>/dev/null || :
    watchdog_pid=''
}

run_probe() {
    name=${probe%%/*}
    binary="$build_dir/$variant-$name"
    if [ ! -x "$binary" ] && ! build_probe; then
        printf 'fail %s %s (could not build probe)\n' "$variant" "$probe" >&2
        return 1
    fi
    set -- "$binary"
    case "$probe" in
        */*) set -- "$@" "${probe#*/}" ;;
    esac
    if [ "$probe" = native/pools ]; then
        set -- env OBJC_DEBUG_MISSING_POOLS=YES "$@"
    fi

    probe_log="$build_dir/probe.log"
    run_timed "$@"
    if grep -Eq 'ERROR: AddressSanitizer|runtime error:|WARNING: ThreadSanitizer|MISSING POOLS' "$probe_log"; then
        printf 'fail %s %s (sanitizer or autorelease pool diagnostic)\n' "$variant" "$probe" >&2
        cat "$probe_log" >&2
        return 1
    fi
    case "$probe:$status" in
        frames:77)
            if grep -qF 'SKIP:frames:real-window-occluded' "$probe_log"; then
                cat "$probe_log"
                return
            fi
            ;;
        native/pools:0 | native/oom:70)
            printf 'pass %s %s\n' "$variant" "$probe"
            return
            ;;
        *:0)
            if grep -qF 'PASS:' "$probe_log"; then
                printf 'pass %s %s\n' "$variant" "$probe"
                return
            fi
            ;;
    esac
    printf 'fail %s %s (exit %s)\n' "$variant" "$probe" "$status" >&2
    cat "$probe_log" >&2
    return 1
}

failures=0
for variant in $variants; do
    while read -r probe modes; do
        case " $modes " in
            *" $variant "*)
                if ! run_probe; then
                    failures=$((failures + 1))
                fi
                ;;
        esac
    done <<'CASES'
native/core plain asan tsan
native/pools plain
native/oom plain
environment plain
resources plain
text/measure plain
shaping/shape plain asan
native/gpu plain asan tsan
native/ui-metal plain asan
frames/fixture plain
frames plain
frames/display plain
frames_multi plain
metal2d/transfer plain
metal2d/images plain
metal2d/render plain
metal2d/compute plain
metal2d/sampling plain
metal2d/srgb plain asan
text/raster plain
shaping/raster plain asan
sheets/alert plain asan tsan
sheets/alert-options plain asan tsan
sheets/alert-options-escape plain asan tsan
sheets/open plain asan tsan
sheets/open-options plain asan tsan
sheets/save plain asan tsan
sheets/open-no-selection plain asan tsan
sheets/save-accept plain asan tsan
sheets/cancel plain asan tsan
sheets/pre-attach plain asan tsan
sheets/cancel-idle plain asan tsan
sheets/window plain asan tsan
sheets/two plain asan tsan
sheets/stop plain asan tsan
sheets/external-stop plain asan tsan
native/ui plain asan
data/model plain
data/tree plain
data/list plain
data/large plain
windows plain
input plain asan
gui/stream plain asan tsan
gui/overflow plain asan tsan
gui/overflow-recovery plain asan tsan
gui/widgets plain asan tsan
gui/menus plain asan tsan
gui/keys plain asan tsan
state plain asan tsan
CASES
done

printf 'Native test failures: %s\n' "$failures"
[ "$failures" -eq 0 ]
