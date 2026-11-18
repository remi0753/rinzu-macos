#!/usr/bin/env python3
"""Verify the macOS SDK event stream, widgets, and window teardown."""

import argparse
import hashlib
import json
import platform
from pathlib import Path
import shutil
import subprocess
import tempfile
import time

from sdk_test_support import (
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
    parser.add_argument("--sanitize", action="store_true")
    parser.add_argument("--tsan", action="store_true")
    parser.add_argument(
        "--gpu",
        action="store_true",
        help="also require real Metal in Source Window scope tests",
    )
    parser.add_argument(
        "--sample",
        action="store_true",
        help="also build and run the native widgets application",
    )
    parser.add_argument(
        "--keep-binary",
        type=Path,
        help="retain AOT and bundle in a dedicated directory; filename must be app",
    )
    parser.add_argument(
        "--mode",
        choices=(
            "all",
            "events",
            "scope",
            "early",
            "cancel",
            "failure",
            "overflow",
            "gpu-recording",
            "gpu-submitted",
        ),
        default="all",
    )
    args = parser.parse_args()
    if args.native_only and args.source_only:
        parser.error("choose native-only or source-only")
    if args.keep_binary and args.keep_binary.name != "app":
        parser.error(
            "--keep-binary must end in /app, preserving the compiled native bundle basename"
        )
    evidence = {
        "schema": "rinzu.macos-gui-v1",
        "platform": platform.platform(),
        "passed": False,
        "cases": [],
        "inputs": {},
    }
    cli, resources = installed_toolchain(args.rinzu)
    evidence["baseline"] = sdk_revision()
    evidence["cliSha256"] = hashlib.sha256(cli.read_bytes()).hexdigest()
    evidence["runnerSha256"] = hashlib.sha256(Path(__file__).read_bytes()).hexdigest()
    args.output.parent.mkdir(parents=True, exist_ok=True)

    def save():
        args.output.write_text(
            json.dumps(evidence, ensure_ascii=False, indent=2) + "\n"
        )

    try:
        with tempfile.TemporaryDirectory(prefix="rinzu-gui-") as directory:
            scratch = Path(directory)
            sdk = stage_sdk(scratch / "sdk")
            for path in sdk.rglob("*"):
                if path.is_file() and path.suffix in (".rinzu", ".toml", ".m", ".h"):
                    evidence["inputs"][str(path.relative_to(scratch))] = hashlib.sha256(
                        path.read_bytes()
                    ).hexdigest()
            env = test_environment(scratch, resources)

            def run(name, command, expected=0, extra=None, markers=(), timeout=300):
                row = {"name": name, "command": list(map(str, command))}
                evidence["cases"].append(row)
                save()
                started = time.monotonic()
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
                save()
                assert result.returncode == expected, row
                assert all(marker in result.stdout for marker in markers), row
                assert not any(
                    value in result.stderr
                    for value in (
                        "ERROR: AddressSanitizer",
                        "runtime error:",
                        "WARNING: ThreadSanitizer",
                        "MISSING POOLS",
                    )
                ), row
                report = (extra or {}).get("RINZU_RESOURCE_REPORT")
                if report:
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
                    ):
                        assert categories[key]["live"] == 0, (
                            name,
                            key,
                            categories[key],
                        )
                    for key in ("callback_control", "callback_entries"):
                        assert categories[key]["allocated"] == 0, (
                            name,
                            key,
                            categories[key],
                        )
                row["passed"] = True
                save()
                print(name + ": passed", flush=True)
                return row

            if not args.source_only:
                flags = [
                    "-std=c11",
                    "-fobjc-arc",
                    "-Wall",
                    "-Wextra",
                    "-Werror",
                    "-I",
                    resources / "include",
                    "-I",
                    sdk / "native/include",
                    sdk / "tests/gui.m",
                    "-framework",
                    "AppKit",
                    "-framework",
                    "Foundation",
                    "-framework",
                    "Metal",
                    "-framework",
                    "QuartzCore",
                    "-framework",
                    "ImageIO",
                    "-framework",
                    "CoreGraphics",
                    "-framework",
                    "CoreText",
                ]
                for variant, extra in [
                    ("native", []),
                    *(
                        [("asan", ["-O1", "-g", "-fsanitize=address,undefined"])]
                        if args.sanitize
                        else []
                    ),
                    *(
                        [("tsan", ["-O1", "-g", "-fsanitize=thread"])]
                        if args.tsan
                        else []
                    ),
                ]:
                    binary = scratch / variant
                    run(
                        variant + "-build",
                        ["xcrun", "clang", *flags, *extra, "-o", binary],
                    )
                    for mode in ("stream", "overflow", "widgets", "menus", "keys"):
                        run(variant + "-" + mode, [binary, mode], timeout=20)
            if not args.native_only:
                app = sdk / "tests/gui"
                run("source-check", [cli, "check", app])
                run("source-build", [cli, "build", app, "--output", scratch / "app"])
                if args.keep_binary:
                    destination = args.keep_binary.resolve()
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    shutil.copy2(scratch / "app", destination)
                    shutil.copy2(
                        scratch / "app.metadata.json",
                        Path(str(destination) + ".metadata.json"),
                    )
                    shutil.copytree(
                        scratch / "app.source-packages",
                        Path(str(destination) + ".source-packages"),
                    )
                    evidence["retainedProgram"] = str(destination)
                    evidence["programSha256"] = hashlib.sha256(
                        destination.read_bytes()
                    ).hexdigest()
                modes = (
                    ["events", "scope", "early", "cancel", "failure", "overflow"]
                    if args.mode == "all"
                    else [args.mode]
                )
                if args.gpu and args.mode == "all":
                    modes += ["gpu-recording", "gpu-submitted"]
                for mode in modes:
                    outputs = []
                    for backend in ("aot", "jit"):
                        report = scratch / (mode + "-" + backend + ".jsonl")
                        command = (
                            [
                                cli,
                                "run",
                                app,
                                "--resource-report",
                                report,
                                "--resource-interval-ms",
                                "0",
                            ]
                            if backend == "jit"
                            else [scratch / "app"]
                        )
                        markers = ["GUI:closed"] + (
                            [] if mode == "cancel" else [f"GUI:{mode}-ok"]
                        )
                        outputs.append(
                            run(
                                "source-" + mode + "-" + backend,
                                command,
                                1 if mode == "cancel" else 0,
                                extra={
                                    "RINZU_GUI_TEST": mode,
                                    "RINZU_RESOURCE_REPORT": str(report),
                                    "RINZU_RESOURCE_INTERVAL_MS": "0",
                                },
                                markers=markers,
                                timeout=180 if backend == "jit" else 20,
                            )
                        )
                    # OS events and startup scheduling may require different native
                    # call counts. Compare observable output and settled resource
                    # reports, not verify-aot's exact deterministic native ledger.
                    assert outputs[0]["stdout"] == outputs[1]["stdout"], outputs
                    evidence["cases"].append(
                        {
                            "name": "source-" + mode + "-equivalence",
                            "comparison": "exit, stdout, terminal runtime live=0",
                            "passed": True,
                        }
                    )
                    save()
                if args.sample:
                    sample = sdk / "examples/macos-widgets"
                    run("sample-check", [cli, "check", sample])
                    run(
                        "sample-build",
                        [cli, "build", sample, "--output", scratch / "widgets"],
                    )
                    sample_outputs = []
                    for backend in ("aot", "jit"):
                        report = scratch / ("sample-" + backend + ".jsonl")
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
                            else [scratch / "widgets"]
                        )
                        sample_outputs.append(
                            run(
                                "sample-" + backend,
                                command,
                                extra={
                                    "RINZU_WIDGETS_TEST": "1",
                                    "RINZU_RESOURCE_REPORT": str(report),
                                    "RINZU_RESOURCE_INTERVAL_MS": "0",
                                },
                                markers=["WIDGETS:closed"],
                                timeout=180 if backend == "jit" else 20,
                            )
                        )
                    assert (
                        sample_outputs[0]["stdout"] == sample_outputs[1]["stdout"]
                    ), sample_outputs
            evidence["passed"] = True
    finally:
        save()


if __name__ == "__main__":
    main()
