"""Locate the installed Rinzu toolchain and isolate SDK test inputs."""

import os
from pathlib import Path
import shutil
import subprocess

ROOT = Path(__file__).resolve().parents[2]
IGNORED_OUTPUTS = shutil.ignore_patterns("build", ".rinzu", "__pycache__", ".DS_Store")


def installed_toolchain(binary):
    cli = binary.resolve(strict=True)
    resources = (cli.parent.parent / "share/rinzu").resolve()
    if not (resources / "include/rinzu/native_completion.h").is_file():
        raise ValueError(
            "pass --rinzu pointing to bin/rinzu in an installed toolchain bundle"
        )
    return cli, resources


def stage_sdk(destination):
    destination.mkdir()
    shutil.copy2(ROOT / "rinzu.toml", destination)
    for folder in ("src", "native", "tests", "examples"):
        shutil.copytree(ROOT / folder, destination / folder, ignore=IGNORED_OUTPUTS)
    return destination


def test_environment(scratch, resources):
    return dict(
        os.environ,
        TMPDIR=str(scratch),
        RINZU_CACHE_DIR=str(scratch / "cache"),
        RINZU_TOOLCHAIN_ROOT=str(resources),
        CLANG_MODULE_CACHE_PATH=str(scratch / "clang-module-cache"),
        ASAN_OPTIONS="detect_leaks=0",
        UBSAN_OPTIONS="halt_on_error=1",
        TSAN_OPTIONS="halt_on_error=1",
    )


def sdk_revision():
    if not (ROOT / ".git").exists():
        return None
    result = subprocess.run(
        ["git", "rev-parse", "--verify", "HEAD"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        check=False,
    )
    return result.stdout.strip() if result.returncode == 0 else None
