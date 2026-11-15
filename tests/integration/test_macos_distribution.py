#!/usr/bin/env python3
"""Exercise the public rinzu.macos module from a clean macOS toolchain bundle."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

from sdk_test_support import IGNORED_OUTPUTS, ROOT, installed_toolchain, test_environment

SDK = "rinzu.macos"
VERSION = "0.1.0"
ARCHIVE = (
    "https://github.com/remi0753/rinzu-macos/releases/download/"
    f"v{VERSION}/rinzu-macos-{VERSION}.tar.gz"
)
SHA256 = "66fffe589c219b728a59e07b28bc236a5b970da32d41b87ef769ea4c46d9fd9a"


def run(label, command, cwd, env, *, expected=0, marker=None):
    result = subprocess.run(
        command, cwd=cwd, env=env, capture_output=True, text=True, timeout=300
    )
    if result.returncode != expected or (
        marker and marker not in result.stdout + result.stderr
    ):
        raise RuntimeError(
            f"{label}: exit {result.returncode}\n{result.stdout}{result.stderr}"
        )
    print(f"{label}: passed", flush=True)
    return result.stdout


def stage_app(source, app):
    shutil.copytree(source, app, ignore=IGNORED_OUTPUTS)
    manifest = app / "rinzu.toml"
    text = manifest.read_text(encoding="utf-8")
    local_dependency = '"rinzu.macos" = { path = "../.." }\n'
    assert text.count(local_dependency) == 1, manifest
    manifest.write_text(text.replace(local_dependency, ""), encoding="utf-8")


def add_module(cli, app, env):
    run(
        f"modules-add-{app.name}",
        [cli, "modules", "add", SDK, ARCHIVE],
        app,
        env,
        marker=f"added {SDK} (sha256:{SHA256})",
    )
    manifest = (app / "rinzu.toml").read_text().splitlines()
    assert f'"{SDK}" = {{ archive = "{ARCHIVE}" }}' in manifest, manifest
    lock_path = app / "rinzu.modules.lock"
    lock = json.loads(lock_path.read_text())
    package = next(package for package in lock["packages"] if package["name"] == SDK)
    pin = package["source"]["archive"]
    assert pin["locator"] == ARCHIVE and pin["sha256"] == SHA256, pin
    stored = app / f"modules/store/sha256/{SHA256}/package"
    assert (stored / "native/src/macos.m").is_file(), stored
    return lock_path


def build_bundle(cli, app, scratch, env, marker):
    expected = run(f"jit-{app.name}", [cli, "run", app], scratch, env, marker=marker)
    bundle = scratch / f"{app.name} 初回.app"
    run(f"bundle-{app.name}", [cli, "bundle", app, "--output", bundle], scratch, env)
    return bundle.rename(scratch / f"{app.name} 移設.app"), expected


def verify_relocated_bundle(cli, bundle, executable, expected, scratch, env):
    run(f"bundle-verify-{executable}", [cli, "bundle-verify", bundle], scratch, env)
    env = dict(env)
    env.pop("RINZU_BUNDLE_DEV_ROOT", None)
    env.pop("RINZU_TOOLCHAIN_ROOT", None)
    env.pop("RINZU_CACHE_DIR", None)
    output = run(
        f"bundle-launch-{executable}",
        [bundle / "Contents/MacOS" / executable],
        scratch,
        env,
    )
    assert output == expected, (output, expected)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rinzu", type=Path, required=True)
    args = parser.parse_args()
    cli, resources = installed_toolchain(args.rinzu)
    if (resources / "sdk/rinzu.macos").exists():
        raise ValueError("pass a toolchain bundle with external native SDK archive support")

    with tempfile.TemporaryDirectory(prefix="rinzu-macos-distribution-") as directory:
        scratch = Path(directory)
        env = test_environment(scratch, resources)
        apps = scratch / "apps"
        apps.mkdir()
        probe = apps / "resources"
        stage_app(ROOT / "tests/bundle", probe)
        run(
            "missing-module",
            [cli, "check", probe],
            scratch,
            env,
            expected=1,
            marker="SDK package `rinzu.macos` is not a declared dependency",
        )
        lock_path = add_module(cli, probe, env)
        lock = lock_path.read_bytes()
        shutil.rmtree(probe / "modules")
        run("modules-restore-offline", [cli, "modules", "sync", "--offline"], probe, env)
        assert lock_path.read_bytes() == lock
        run("native-lock", [cli, "lock", probe], scratch, env)
        run("native-lock-check", [cli, "lock", probe, "--check"], scratch, env)

        samples = sorted((ROOT / "examples").glob("*/rinzu.toml"))

        def check_sample(manifest):
            app = apps / manifest.parent.name
            stage_app(manifest.parent, app)
            add_module(cli, app, env)
            run(f"check-{app.name}", [cli, "check", app], scratch, env)

        with ThreadPoolExecutor(max_workers=4) as executor:
            list(executor.map(check_sample, samples))

        probe_env = dict(env, RINZU_BUNDLE_DEV_ROOT=str(probe))
        probe_bundle, probe_stdout = build_bundle(
            cli, probe, scratch, probe_env, "BUNDLE:closed"
        )
        sample_env = dict(env, RINZU_MACOS_FRAMES="3")
        metal_bundle, metal_stdout = build_bundle(
            cli, apps / "macos-metal", scratch, sample_env, "MACOS:compute-ok"
        )
        assert "MACOS:frames=3" in metal_stdout and "MACOS:closed" in metal_stdout

        shutil.rmtree(apps)
        shutil.rmtree(Path(env["RINZU_CACHE_DIR"]), ignore_errors=True)
        verify_relocated_bundle(
            cli,
            probe_bundle,
            "macos_bundle_probe",
            probe_stdout,
            scratch,
            dict(env, RINZU_BUNDLE_EXPECT_APP="1"),
        )
        verify_relocated_bundle(
            cli, metal_bundle, "macos_metal", metal_stdout, scratch, sample_env
        )
        (probe_bundle / "Contents/Resources/app/assets/日本語.txt").write_text(
            "tampered", encoding="utf-8"
        )
        run(
            "bundle-rejects-changed-asset",
            [cli, "bundle-verify", probe_bundle],
            scratch,
            env,
            expected=1,
            marker="inventory changed",
        )


if __name__ == "__main__":
    main()
