#!/usr/bin/env python3
"""Verify the external SDK, its explicit dependency, and a relocated .app."""

import argparse
import json
from pathlib import Path
import shutil
import subprocess
import tempfile

from sdk_test_support import installed_toolchain, stage_sdk, test_environment


def run(label, command, scratch, env, *, expected=0, marker=None):
    result = subprocess.run(
        command, cwd=scratch, env=env, capture_output=True, text=True, timeout=300
    )
    if result.returncode != expected or (
        marker and marker not in result.stdout + result.stderr
    ):
        raise RuntimeError(
            f"{label}: exit {result.returncode}\n{result.stdout}{result.stderr}"
        )
    print(f"{label}: passed", flush=True)
    return result.stdout


def compare_public_api(cli, original, sdk, scratch, env):
    baseline = scratch / "bundled.json"
    external = scratch / "external.json"
    run("bundled-api", [cli, "api", original, "--output", baseline], scratch, env)
    run(
        "external-api",
        [cli, "api", sdk, "--output", external, "--compare", baseline],
        scratch,
        env,
    )
    report = json.loads(external.with_suffix(".report.json").read_text())
    assert report["package"] == "rinzu.macos", report
    assert not report["breaking_candidates"] and not report["additions"], report


def verify_relocated_bundle(cli, sdk, scratch, env):
    app = sdk / "tests/bundle"
    runtime_env = dict(env, RINZU_BUNDLE_DEV_ROOT=str(app))
    expected = run(
        "bundle-fixture-jit",
        [cli, "run", app],
        scratch,
        runtime_env,
        marker="BUNDLE:closed",
    )
    initial = scratch / "Initial 日本語.app"
    run("bundle", [cli, "bundle", app, "--output", initial], scratch, env)
    moved = initial.rename(scratch / "Moved 東京.app")
    # Remove the exact SDK and application sources used in this build before launch.
    shutil.rmtree(sdk)
    shutil.rmtree(Path(env["RINZU_CACHE_DIR"]), ignore_errors=True)
    run("relocated-bundle-verify", [cli, "bundle-verify", moved], scratch, env)
    runtime_env = dict(env, RINZU_BUNDLE_EXPECT_APP="1")
    runtime_env.pop("RINZU_BUNDLE_DEV_ROOT", None)
    runtime_env.pop("RINZU_TOOLCHAIN_ROOT", None)
    executable = moved / "Contents/MacOS/macos_bundle_probe"
    actual = run(
        "relocated-bundle-launch",
        [executable],
        scratch,
        runtime_env,
        marker="BUNDLE:closed",
    )
    assert actual == expected, (actual, expected)
    asset = moved / "Contents/Resources/app/assets/日本語.txt"
    asset.write_text("tampered", encoding="utf-8")
    run(
        "bundle-rejects-changed-asset",
        [cli, "bundle-verify", moved],
        scratch,
        env,
        expected=1,
        marker="inventory changed",
    )


def verify_explicit_dependency(cli, scratch, env):
    sdk = stage_sdk(scratch / "dependency")
    app = scratch / "consumer"
    (app / "src").mkdir(parents=True)
    (app / "rinzu.toml").write_text(
        '[package]\nname = "sdk_consumer"\nlanguage = "0.5"\n\n'
        '[dependencies]\n"rinzu.macos" = { path = "../dependency" }\n',
        encoding="utf-8",
    )
    (app / "src/main.rinzu").write_text(
        "import rinzu.macos;\n"
        'fn main() { if rinzu.macos.migrationProbe() != 42 { panic("wrong SDK"); } }\n',
        encoding="utf-8",
    )
    # This export exists exclusively in the explicitly selected source checkout.
    with (sdk / "src/macos.rinzu").open("a", encoding="utf-8") as source:
        source.write(
            "\nfn migrationProbe() -> Int { return 42; }\nexport migrationProbe;\n"
        )
    run("explicit-dependency-lock", [cli, "lock", app], scratch, env)
    run("explicit-dependency-lock-check", [cli, "lock", app, "--check"], scratch, env)
    run("explicit-dependency-jit", [cli, "run", app], scratch, env)
    sdk.rename(scratch / "unavailable")
    run(
        "missing-explicit-dependency",
        [cli, "check", app],
        scratch,
        env,
        expected=1,
        marker="cannot resolve dependency `rinzu.macos`",
    )


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--rinzu", type=Path, required=True)
    args = parser.parse_args()
    cli, resources = installed_toolchain(args.rinzu)
    with tempfile.TemporaryDirectory(prefix="rinzu-macos-distribution-") as directory:
        scratch = Path(directory)
        env = test_environment(scratch, resources)
        sdk = stage_sdk(scratch / "sdk")
        for area in ("tests", "examples"):
            for manifest in sorted((sdk / area).glob("*/rinzu.toml")):
                run(
                    f"check-{area}-{manifest.parent.name}",
                    [cli, "check", manifest.parent],
                    scratch,
                    env,
                )
        bundled = resources / "sdk/rinzu.macos"
        if bundled.is_dir():
            compare_public_api(cli, bundled, sdk, scratch, env)
        verify_explicit_dependency(cli, scratch, env)
        verify_relocated_bundle(cli, sdk, scratch, env)


if __name__ == "__main__":
    main()
