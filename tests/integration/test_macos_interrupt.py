#!/usr/bin/env python3
"""Send exactly one SIGINT after the real AppKit callback enters the run loop."""

import argparse
import os
from pathlib import Path
import plistlib
import selectors
import signal
import subprocess
import sys
import tempfile
import time

from sdk_test_support import installed_toolchain, stage_sdk, test_environment

INHERIT = """import os, signal, sys
policy = int(sys.argv[1])
if policy:
    signal.signal(signal.SIGINT, signal.SIG_IGN)
if policy == 2:
    signal.pthread_sigmask(signal.SIG_BLOCK, [signal.SIGINT])
os.execv(sys.argv[2], sys.argv[2:])
"""
POLICIES = ("default", "ignored", "ignored-and-blocked")


def interrupt(command, policy, scratch, env):
    launch = [sys.executable, "-B", "-c", INHERIT, str(policy), *map(str, command)]
    with tempfile.TemporaryFile(dir=scratch) as stdout:
        with subprocess.Popen(
            launch,
            cwd=scratch,
            env=env,
            stdout=stdout,
            stderr=subprocess.PIPE,
            start_new_session=True,
        ) as child:
            observed = bytearray()
            try:
                with selectors.DefaultSelector() as ready:
                    ready.register(child.stderr, selectors.EVENT_READ)
                    deadline = time.monotonic() + 90
                    while b"TERMINATION_MARK=10\n" not in observed:
                        remaining = deadline - time.monotonic()
                        if remaining <= 0 or not ready.select(timeout=remaining):
                            raise TimeoutError("AppKit callback did not start")
                        piece = os.read(child.stderr.fileno(), 4096)
                        if not piece:
                            raise RuntimeError(observed.decode(errors="replace"))
                        observed.extend(piece)
                        if len(observed) > 65536:
                            raise RuntimeError(
                                "AppKit callback did not start within the log bound"
                            )
                os.killpg(child.pid, signal.SIGINT)
                _, remainder = child.communicate(timeout=3)
                observed.extend(remainder)
            finally:
                if child.poll() is None:
                    try:
                        os.killpg(child.pid, signal.SIGKILL)
                    except ProcessLookupError:
                        pass
                    child.communicate()
        stdout.seek(0)
        assert b"RINZU_NATIVE_CALLS=" not in stdout.read(), observed
    assert child.returncode == -signal.SIGINT, observed
    assert b"TERMINATION_MARK=1\n" in observed, observed
    for marker in (2, 3, 4, 5, 9):
        assert f"TERMINATION_MARK={marker}\n".encode() not in observed, observed
    assert (
        b"ERROR: AddressSanitizer" not in observed and b"runtime error:" not in observed
    ), observed


def stage_interrupt(scratch):
    sdk = stage_sdk(scratch / "sdk")
    fixtures = sdk / "tests/interrupt"
    with (sdk / "src/macos.rinzu").open("a", encoding="utf-8") as source:
        source.write(
            '\nnative { fn interruptMark(marker: CInt) symbol "rinzu_macos_interrupt_mark"; }\n'
            "export interruptMark;\n"
        )
    with (sdk / "native/include/rinzu_macos.h").open("a", encoding="utf-8") as header:
        header.write("\nvoid rinzu_macos_interrupt_mark(int32_t marker);\n")
    native = sdk / "native/src/macos.m"
    source = native.read_text(encoding="utf-8")
    old = "session->handler = NULL;"
    assert source.count(old) == 1
    source = source.replace(old, f"rinzu_macos_interrupt_mark(9); {old}")
    native.write_text(source + (fixtures / "markers.m").read_text(), encoding="utf-8")
    app = scratch / "interrupt"
    (app / "src").mkdir(parents=True)
    (app / "rinzu.toml").write_text(
        '[package]\nname = "macos_interrupt"\nlanguage = "0.5"\n\n'
        '[dependencies]\n"rinzu.macos" = { path = "../sdk" }\n',
        encoding="utf-8",
    )
    (app / "src/main.rinzu").write_bytes((fixtures / "main.rinzu.in").read_bytes())
    return app


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rinzu", type=Path, required=True)
    parser.add_argument("--sanitize", action="store_true")
    args = parser.parse_args()
    cli, resources = installed_toolchain(args.rinzu)
    with tempfile.TemporaryDirectory(prefix="rinzu-macos-interrupt-") as directory:
        scratch = Path(directory)
        env = test_environment(scratch, resources)

        def checked(command):
            subprocess.run(command, cwd=scratch, env=env, check=True, timeout=300)

        app = stage_interrupt(scratch)
        binary = scratch / "app"
        checked([cli, "build", app, "--output", binary])
        commands = {"jit": [cli, "run", app], "aot": [binary]}
        if args.sanitize:
            sanitized = scratch / "app-sanitized"
            checked(
                [
                    "xcrun",
                    "clang",
                    "-std=c11",
                    "-O1",
                    "-g",
                    "-Wno-unused-label",
                    "-pthread",
                    "-fsanitize=address,undefined",
                    "-fno-omit-frame-pointer",
                    binary.with_suffix(".o"),
                    binary.with_suffix(".runtime.c"),
                    resources / "runtime/callback_entry.c",
                    resources / "runtime/callback_template.S",
                    resources / "runtime/owner_dispatcher.c",
                    "-I",
                    resources / "include",
                    "-framework",
                    "CoreFoundation",
                    "-o",
                    sanitized,
                ]
            )
            for suffix in (".source-packages", ".resources"):
                sidecar = binary.with_suffix(suffix)
                if sidecar.exists():
                    sanitized.with_suffix(suffix).symlink_to(sidecar)
            commands["sanitized-aot"] = [sanitized]

        for mode, command in commands.items():
            for policy, name in enumerate(POLICIES):
                interrupt(command, policy, scratch, env)
                print(f"interrupt-{mode}-{name}: passed", flush=True)

        entitlements = scratch / "test-entitlements.plist"
        entitlements.write_bytes(
            plistlib.dumps({"com.apple.security.cs.disable-library-validation": True})
        )
        checked(
            [
                "codesign",
                "--force",
                "--sign",
                "-",
                "--options",
                "runtime",
                "--entitlements",
                entitlements,
                binary,
            ]
        )
        checked(["codesign", "--verify", "--strict", binary])
        for policy, name in enumerate(POLICIES):
            interrupt([binary], policy, scratch, env)
            print(f"interrupt-signed-aot-{name}: passed", flush=True)


if __name__ == "__main__":
    main()
