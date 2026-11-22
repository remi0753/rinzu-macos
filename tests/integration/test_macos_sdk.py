#!/usr/bin/env python3
"""Replay native AppKit/Metal boundaries and ordinary source JIT/AOT integration."""

import argparse
import hashlib
import json
from pathlib import Path
import platform
import subprocess
import tempfile
import time

from sdk_test_support import (
    ROOT,
    installed_toolchain,
    sdk_revision,
    stage_sdk,
    test_environment,
)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rinzu", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--native-only", action="store_true")
    parser.add_argument("--source-only", action="store_true")
    parser.add_argument(
        "--phase",
        choices=(
            "all",
            "core",
            "callback",
            "gpu",
            "recording",
            "close",
            "cancel",
            "sample",
        ),
        default="all",
    )
    parser.add_argument(
        "--ui", action="store_true", help="finite desktop windows, automatically closed"
    )
    parser.add_argument(
        "--require-gpu",
        action="store_true",
        help="no-device is a failure instead of skip",
    )
    parser.add_argument("--sanitize", action="store_true")
    parser.add_argument(
        "--timeout",
        type=int,
        default=900,
        help="seconds per source check, build, or execution",
    )
    parser.add_argument(
        "--tsan",
        action="store_true",
        help="check native completion publication with ThreadSanitizer",
    )
    args = parser.parse_args()
    if args.native_only and args.source_only:
        parser.error("choose at most one of --native-only / --source-only")
    if args.native_only and args.phase != "all":
        parser.error("--phase selects source tests; omit --native-only")
    if (
        args.source_only
        and args.phase in ("gpu", "recording", "close", "cancel")
        and not args.require_gpu
    ):
        parser.error("a source-only GPU phase requires --require-gpu")
    if args.phase == "sample" and not (args.ui and args.require_gpu):
        parser.error("sample phase requires --ui --require-gpu")
    if args.phase == "callback" and not args.ui:
        parser.error("callback phase requires --ui for its finite NSApplication run")
    cli, resources = installed_toolchain(args.rinzu)
    evidence = {
        "schema": "rinzu.macos-sdk-v1",
        "baseline": sdk_revision(),
        "platform": platform.platform(),
        "requiredGpu": args.require_gpu,
        "ui": args.ui,
        "phase": args.phase,
        "passed": False,
        "cases": [],
    }
    evidence["inputs"] = {
        str(path.relative_to(ROOT)): hashlib.sha256(path.read_bytes()).hexdigest()
        for folder in (ROOT / "src", ROOT / "native", ROOT / "tests", ROOT / "examples")
        for path in folder.rglob("*")
        if path.is_file()
        and path.suffix in (".rinzu", ".toml", ".m", ".h", ".c", ".cpp", ".mm")
        and not {"build", ".rinzu"}.intersection(path.parts)
    }
    evidence["inputs"]["rinzu.toml"] = hashlib.sha256(
        (ROOT / "rinzu.toml").read_bytes()
    ).hexdigest()
    for relative in (
        "include/rinzu/native_completion.h",
        "include/rinzu/native_bytes.h",
    ):
        evidence["inputs"][relative] = hashlib.sha256(
            (resources / relative).read_bytes()
        ).hexdigest()
    evidence["runnerSha256"] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    evidence["cliSha256"] = hashlib.sha256(cli.read_bytes()).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    def save():
        args.output.write_text(
            json.dumps(evidence, ensure_ascii=False, indent=2) + "\n"
        )

    try:
        with tempfile.TemporaryDirectory(prefix="rinzu-macos-sdk-") as directory:
            scratch = Path(directory)
            env = test_environment(scratch, resources)

            def run(
                name,
                command,
                expected=0,
                extra=None,
                contains=(),
                skip=False,
                timeout=None,
                allow_occluded=False,
            ):
                timeout = args.timeout if timeout is None else timeout
                started = time.monotonic()
                row = {"name": name, "command": list(map(str, command))}
                evidence["cases"].append(row)
                save()
                try:
                    result = subprocess.run(
                        command,
                        cwd=scratch,
                        env=dict(env, **(extra or {})),
                        capture_output=True,
                        text=True,
                        timeout=timeout,
                    )
                except subprocess.TimeoutExpired as error:
                    row.update(
                        timeout=True,
                        seconds=time.monotonic() - started,
                        stdout=(error.stdout or b"").decode(errors="replace"),
                        stderr=(error.stderr or b"").decode(errors="replace"),
                    )
                    save()
                    raise
                row.update(
                    exit=result.returncode,
                    stdout=result.stdout,
                    stderr=result.stderr,
                    seconds=time.monotonic() - started,
                )
                if skip and result.returncode == 77:
                    row["skipped"] = True
                    save()
                    if args.require_gpu:
                        raise AssertionError(f"{name}: required GPU unavailable")
                    print(name + ": skipped (no Metal device)", flush=True)
                    return False
                if (
                    allow_occluded
                    and result.returncode == 77
                    and "SKIP:frames:real-window-occluded" in result.stdout
                ):
                    row["skipped"] = True
                    save()
                    print(name + ": skipped (window occluded)", flush=True)
                    return False
                assert result.returncode == expected, row
                for value in contains:
                    assert value in result.stdout, row
                assert (
                    "ERROR: AddressSanitizer" not in result.stderr
                    and "runtime error:" not in result.stderr
                ), row
                assert "MISSING POOLS" not in result.stderr, row
                report = (extra or {}).get("RINZU_RESOURCE_REPORT")
                if report and Path(report).exists():
                    records = [
                        json.loads(line)
                        for line in Path(report).read_text().splitlines()
                    ]
                    row["resourcesEnd"] = records[-1]
                    categories = {
                        item["id"]: item for item in records[-1]["categories"]
                    }
                    for key in (
                        "managed",
                        "task",
                        "future",
                        "pending_operation",
                        "transport",
                        "native_calls",
                        "callback_scoped",
                        "callback_in_flight",
                        "foreign_queue",
                    ):
                        assert categories[key]["live"] == 0, (
                            name,
                            key,
                            categories[key],
                        )
                elif report:
                    raise AssertionError(f"{name}: resource report was not written")
                row["passed"] = True
                save()
                print(f"{name}: passed ({row['seconds']:.2f}s)", flush=True)
                return row

            def compare_live_runs(name, runs):
                jit, aot = runs
                assert (jit["exit"], jit["stdout"]) == (
                    aot["exit"],
                    aot["stdout"],
                ), runs
                evidence["cases"].append(
                    {
                        "name": name,
                        "passed": True,
                        "comparison": "exit, stdout, terminal runtime live=0",
                    }
                )
                save()
                print(name + ": passed", flush=True)

            gpu = args.require_gpu
            if not args.source_only:
                native = scratch / "native"
                flags = [
                    "-std=c11",
                    "-fobjc-arc",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-I",
                    resources / "include",
                    "-I",
                    ROOT / "native/include",
                ]
                frameworks = [
                    "AppKit",
                    "Foundation",
                    "Metal",
                    "QuartzCore",
                    "ImageIO",
                    "CoreGraphics",
                    "CoreText",
                ]
                for framework in frameworks:
                    flags.extend(["-framework", framework])

                def build_probe(case, name, binary, extra=()):
                    run(
                        case,
                        [
                            "xcrun",
                            "clang",
                            *flags,
                            *extra,
                            ROOT / f"tests/{name}.m",
                            "-o",
                            binary,
                        ],
                    )

                build_probe("native-build", "native", native)
                run("native-core", [native, "core"])
                run(
                    "native-pools",
                    [native, "pools"],
                    extra={"OBJC_DEBUG_MISSING_POOLS": "YES"},
                )
                run("native-oom", [native, "oom"], expected=70)
                gpu = run("native-gpu", [native, "gpu"], skip=True)
                if args.ui:
                    run("native-ui", [native, "ui"], timeout=45)
                    if gpu:
                        run("native-ui-metal", [native, "ui-metal"], timeout=45)
                probes = {
                    "data": ["model", "tree"],
                    "resources": [""],
                    "environment": [""],
                    "text": ["measure"],
                    "shaping": ["shape"],
                }
                if gpu:
                    probes["text"].append("raster")
                    probes["shaping"].append("raster")
                    probes["metal2d"] = [
                        "transfer",
                        "images",
                        "render",
                        "compute",
                        "sampling",
                        "srgb",
                    ]
                if args.ui:
                    probes["input"] = [""]
                    probes["data"].extend(["list", "large"])
                    if gpu:
                        probes["frames"] = ["fixture", "", "display"]
                        probes["frames_multi"] = [""]
                for name, modes in probes.items():
                    binary = scratch / f"native-{name}"
                    build_probe(f"native-{name}-build", name, binary)
                    for mode in modes:
                        command = [binary, mode] if mode else [binary]
                        run(
                            f"native-{name}-{mode}" if mode else f"native-{name}",
                            command,
                            contains=["PASS:"],
                            timeout=45,
                            allow_occluded=name == "frames" and not mode,
                        )
                if args.sanitize:
                    sanitized = scratch / "native-sanitized"
                    build_probe(
                        "sanitizer-build",
                        "native",
                        sanitized,
                        [
                            "-O1",
                            "-g",
                            "-fsanitize=address,undefined",
                            "-fno-omit-frame-pointer",
                        ],
                    )
                    run("sanitizer-core", [sanitized, "core"])
                    if gpu:
                        run("sanitizer-gpu", [sanitized, "gpu"])
                    if args.ui:
                        run("sanitizer-ui", [sanitized, "ui"], timeout=45)
                        if gpu:
                            run(
                                "sanitizer-ui-metal",
                                [sanitized, "ui-metal"],
                                timeout=45,
                            )
                        input_probe = scratch / "input-sanitized"
                        build_probe(
                            "input-sanitizer-build",
                            "input",
                            input_probe,
                            [
                                "-O1",
                                "-g",
                                "-fsanitize=address,undefined",
                                "-fno-omit-frame-pointer",
                            ],
                        )
                        run("input-sanitizer", [input_probe], contains=["PASS:"])
                    shaped = scratch / "shaping-sanitized"
                    build_probe(
                        "shaping-sanitizer-build",
                        "shaping",
                        shaped,
                        [
                            "-O1",
                            "-g",
                            "-fsanitize=address,undefined",
                            "-fno-omit-frame-pointer",
                        ],
                    )
                    run(
                        "shaping-sanitizer-shape", [shaped, "shape"], contains=["PASS:"]
                    )
                    if gpu:
                        run(
                            "shaping-sanitizer-raster",
                            [shaped, "raster"],
                            contains=["PASS:"],
                        )
                    if gpu:
                        color = scratch / "metal2d-sanitized"
                        build_probe(
                            "metal2d-sanitizer-build",
                            "metal2d",
                            color,
                            [
                                "-O1",
                                "-g",
                                "-fsanitize=address,undefined",
                                "-fno-omit-frame-pointer",
                            ],
                        )
                        run(
                            "metal2d-sanitizer-srgb",
                            [color, "srgb"],
                            contains=["PASS:"],
                        )
                if args.tsan:
                    threaded = scratch / "native-tsan"
                    build_probe(
                        "tsan-build",
                        "native",
                        threaded,
                        ["-O1", "-g", "-fsanitize=thread"],
                    )
                    run(
                        "tsan-core",
                        [threaded, "core"],
                        extra={"TSAN_OPTIONS": "halt_on_error=1"},
                    )
                    if gpu:
                        run(
                            "tsan-gpu",
                            [threaded, "gpu"],
                            extra={"TSAN_OPTIONS": "halt_on_error=1"},
                        )
            if not args.native_only:
                staged_sdk = stage_sdk(scratch / "sdk")
                app = staged_sdk / "tests/app"
                modes = (
                    ["core"]
                    + (["callback"] if args.ui else [])
                    + (["gpu", "recording", "close", "cancel"] if gpu else [])
                )
                if args.phase != "all":
                    modes = [mode for mode in modes if mode == args.phase]
                if modes:
                    run("source-check", [cli, "check", app])
                    run(
                        "source-build", [cli, "build", app, "--output", scratch / "app"]
                    )
                for mode in modes:
                    expected = 1 if mode == "cancel" else 0
                    markers = ["SOURCE:closed"]
                    if mode in ("core", "gpu", "close"):
                        markers.append(f"SOURCE:{mode}-ok")
                    if mode == "core":
                        markers.append("SOURCE:shaping-ok:7:owned:styles:utf16")
                    if mode == "callback":
                        markers.append("SOURCE:callback-ok:2:42")
                    runs = []
                    for backend in ("jit", "aot"):
                        report = scratch / f"{mode}-{backend}.jsonl"
                        command = (
                            [
                                cli,
                                "run",
                                app,
                                "--resource-report",
                                str(report),
                                "--resource-interval-ms",
                                "0",
                            ]
                            if backend == "jit"
                            else [scratch / "app"]
                        )
                        runs.append(
                            run(
                                f"source-{mode}-{backend}",
                                command,
                                expected,
                                extra={
                                    "RINZU_MACOS_TEST": mode,
                                    "RINZU_RESOURCE_REPORT": str(report),
                                    "RINZU_RESOURCE_INTERVAL_MS": "0",
                                    "RINZU_GC_STRESS": (
                                        "1" if mode == "callback" else "0"
                                    ),
                                },
                                contains=markers,
                                timeout=(
                                    45
                                    if mode == "callback" and backend == "aot"
                                    else None
                                ),
                            )
                        )
                    if mode == "callback" and args.sanitize:
                        sanitized = scratch / "app.sanitized"
                        run(
                            "source-callback-sanitizer-build",
                            [
                                "xcrun",
                                "clang",
                                "-std=c11",
                                "-O1",
                                "-g",
                                "-fsanitize=address,undefined",
                                "-fno-omit-frame-pointer",
                                "-pthread",
                                scratch / "app.o",
                                scratch / "app.runtime.c",
                                resources / "runtime/callback_entry.c",
                                resources / "runtime/callback_template.S",
                                resources / "runtime/owner_dispatcher.c",
                                "-I",
                                resources / "include",
                                "-framework",
                                "CoreFoundation",
                                "-o",
                                sanitized,
                            ],
                        )
                        report = scratch / "callback-sanitized.jsonl"
                        run(
                            "source-callback-sanitized",
                            [sanitized],
                            extra={
                                "RINZU_MACOS_TEST": mode,
                                "RINZU_GC_STRESS": "1",
                                "RINZU_RESOURCE_REPORT": str(report),
                                "RINZU_RESOURCE_INTERVAL_MS": "0",
                            },
                            contains=markers,
                            timeout=45,
                        )
                    if mode == "callback":
                        # NSApplication can deliver extra callbacks for unrelated
                        # window events. The Source fixture checks the two start
                        # callbacks and releases its native resources in both runs.
                        for category in ("native_calls", "callback_entries"):
                            allocated = [
                                next(
                                    item["allocated"]
                                    for item in row["resourcesEnd"]["categories"]
                                    if item["id"] == category
                                )
                                for row in runs
                            ]
                            assert allocated[0] == allocated[1], (category, allocated)
                        compare_live_runs("source-callback-equivalence", runs)
                    else:
                        run(
                            f"source-{mode}-equivalence",
                            [cli, "verify-aot", app],
                            extra={"RINZU_MACOS_TEST": mode},
                            contains=["JIT/AOT equivalent:"],
                        )
                if args.ui and gpu and args.phase in ("all", "sample"):
                    sample = staged_sdk / "examples/macos-metal"
                    run("sample-check", [cli, "check", sample])
                    run(
                        "sample-build",
                        [cli, "build", sample, "--output", scratch / "sample"],
                    )
                    runs = []
                    for backend in ("jit", "aot"):
                        report = scratch / f"sample-{backend}.jsonl"
                        command = (
                            [
                                cli,
                                "run",
                                sample,
                                "--resource-report",
                                report,
                                "--resource-interval-ms",
                                "0",
                            ]
                            if backend == "jit"
                            else [scratch / "sample"]
                        )
                        runs.append(
                            run(
                                "sample-" + backend,
                                command,
                                extra={
                                    "RINZU_MACOS_FRAMES": "3",
                                    "RINZU_RESOURCE_REPORT": str(report),
                                    "RINZU_RESOURCE_INTERVAL_MS": "0",
                                },
                                contains=[
                                    "MACOS:compute-ok",
                                    "MACOS:frames=3",
                                    "MACOS:closed",
                                ],
                            )
                        )
                    compare_live_runs("sample-equivalence", runs)
                    canvas = staged_sdk / "tests/canvas-geometry"
                    run("canvas-check", [cli, "check", canvas])
                    run(
                        "canvas-build",
                        [cli, "build", canvas, "--output", scratch / "canvas"],
                    )
                    runs = []
                    for backend in ("jit", "aot"):
                        report = scratch / f"canvas-{backend}.jsonl"
                        command = (
                            [
                                cli,
                                "run",
                                canvas,
                                "--resource-report",
                                report,
                                "--resource-interval-ms",
                                "0",
                            ]
                            if backend == "jit"
                            else [scratch / "canvas"]
                        )
                        runs.append(
                            run(
                                "canvas-" + backend,
                                command,
                                extra={
                                    "RINZU_RESOURCE_REPORT": str(report),
                                    "RINZU_RESOURCE_INTERVAL_MS": "0",
                                },
                                contains=["CANVAS:geometry-retry:closed"],
                            )
                        )
                    compare_live_runs("canvas-equivalence", runs)
            evidence["passed"] = True
    finally:
        save()


if __name__ == "__main__":
    main()
