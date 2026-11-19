# rinzu.macos

AppKit, CoreText, and Metal SDK for Rinzu on Apple Silicon. It provides native windows and controls, owned events, async UI scopes, 2D drawing, GPU resources, and document and sheet APIs.

## Install

Use a macOS arm64 Rinzu toolchain with native SDK archive support. Run GUI applications from a desktop session. [v0.1.2 release](https://github.com/remi0753/rinzu-macos/releases/tag/v0.1.2)

From your application directory, register the module and refresh the native build lock.

```sh
rinzu modules add rinzu.macos https://github.com/remi0753/rinzu-macos/releases/download/v0.1.2/rinzu-macos-0.1.2.tar.gz
rinzu lock .
```

Use `import rinzu.macos;` in the application. Commit the manifest and `rinzu.modules.lock`, then use `rinzu modules sync` in other checkouts. Rinzu compiles the archived Objective-C sources with the local Xcode toolchain.

The examples in this SDK checkout use its sources for SDK development. Start with the [GUI guide](docs/guide.md), [API reference](docs/api.md), or [Metal example](examples/macos-metal/src/main.rinzu).

## Start and stop an application

application(title,width,height,body) owns the OS loop and invokes an async body receiving UiApplication. applicationWithSignals also registers cooperative process signals. Use app.primary for the initial UiScope and app.session for session-wide operations.

A scope owns its window, resources, and jobs. Dispatch owned UiEvent values in managed async handlers. Request stop when closing or quitting, stop intake, and await jobs/native/GPU completion before releasing their resources. Application shutdown is explicit; a native window does not become a transferable Worker value.

Session/Window/View and rendering resources are managed classes wrapping exported opaque handle types. Opaque handles have no methods or constructors and are used at the native ABI. Rect, Color, Event, and statistics are native scalar records with automatic writeback.

The low-level run handler has type fn(RunContext,Event)->Unit. RunContext is a language record containing session. Native code keeps the context through actual call/callback settlement and uses its checked fallback. Do not retain arbitrary managed callbacks outside supported call lifetimes.

## Controls and events

The SDK includes labels, buttons, text fields/views, menus, checkboxes, layout helpers, accessibility, tooltips, themes, focus/scroll state, and owned window events. Keep application save/close policies in managed handlers. Programmatic state updates do not automatically reproduce user events.

Native views and Metal surfaces report raw key-down and key-up events. `UiEvent.text` owns the event's `NSEvent.characters` as UTF-8, including control characters and NUL. `keyCode` and `modifiers` retain the native values; `flags & keyRepeat` identifies repeats. The existing event queue limits apply to these snapshots. Applications interpret key meaning. Input-method composition is provided by native text controls.

List/table/tree DataView models use stable row IDs, columns, selection, expansion, sorting, and owned cell values. Dataset limits are 100000 rows, 32 columns, 16 MiB UTF-8 content, and tree depth 64. Generation yields every 256 rows and commits a completed model; failed or stopped updates discard uncommitted state. Serialize competing async operations on a view. These are bounded copied models, not remote paging or unbounded lists.

## Drawing and GPU resources

Metal APIs cover devices, buffers, textures, samplers, pipelines, compute/render commands, offscreen targets, uploads/readback, and asynchronous GPU completion. Resources must remain live through submitted work. Await physical completion before reuse or destroy.

Batch2D preserves draw order and batches compatible texture/filter/clip operations. Low-level coordinates are top-left drawable pixels. The managed canvas uses points with backing scale, and offers explicit pixel mode. Images are decoded/uploaded on Main. Text2D is a reusable shaped-text/texture snapshot; rebuild it when text changes.

Surface rendering admits only a drawable matching the captured pixel extent. `Command.beginRenderMatching` exposes that check; a size mismatch remains idle and unleased. Canvas jobs manage a surface, batch, frame waits, and cleanup. Invalidation coalesces requests. Idle/hidden/minimized/occluded views stop their frame timer; unavailable drawables use bounded backoff. FrameClock schedules Main RunLoop deadlines and does not promise display-link synchronization or exact FPS.

## Documents and sheets

The document layer provides state, selection, undo/redo, snapshots, and explicit file saving. Await saves and resource users before closing. Open/save panels and alert sheets complete asynchronously; distinguish user cancellation from ordinary Error and runtime cancellation. Keep UI event and text ownership rules when composing IME or document callbacks.

## Bundled resources

session.resourceRoot returns Option<String> for application assets, or None in an ordinary JIT/console host. resourcePath validates a package-relative name and returns its bundled absolute path without reading it or changing cwd.

Use rinzu bundle to create an application from macos-app.json, then bundle-verify to inspect the generated inventory and ad-hoc signature. Keep the entire bundle together. Native OS-image compatibility still applies. Developer ID signing, notarization, and App Store submission are separate distribution steps.

See [AOT and bundle distribution](https://github.com/remi0753/rinzu/blob/v0.3.0/docs/tooling/distribution.md).

Local candidates can be checked before publishing with `test_macos_distribution.py --archive /path/to/candidate.tar.gz --sha256 DIGEST` using the installed toolchain. The same check covers archive integrity, offline restoration, JIT and relocated signed bundles.

## Compatibility and source provenance

| SDK tag  | Dependency                        | Rinzu                                     | Target      |
| -------- | --------------------------------- | ----------------------------------------- | ----------- |
| `v0.1.2` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.1` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.0` | Published module                  | Toolchain with native SDK archive support | macOS arm64 |
| `v0.1.0` | SDK checkout                      | Released Rinzu `0.3.0`                    | macOS arm64 |

The SDK, examples, and original test vectors come from the [Rinzu v0.3.0 source tree](https://github.com/remi0753/rinzu/tree/7aa3591af36cf4635f579a8d12803362dc48bff8/sdk/macos). The repository records upstream commit `7aa3591af36cf4635f579a8d12803362dc48bff8` as the extraction baseline.

## Verify the SDK

Provide a `bin/rinzu` from the installed toolchain bundle so the native probes use the distributed ABI headers. Run the GUI cases from an unlocked desktop session with Metal available. The runners build in temporary directories and write any requested reports to the paths you supply.

```sh
rinzu_cli=/path/to/rinzu-toolchain/bin/rinzu
sdk_reports=$(mktemp -d)
trap 'rm -rf "$sdk_reports"' EXIT

python3 -B tests/integration/test_macos_distribution.py --rinzu "$rinzu_cli"
python3 -B tests/integration/test_macos_sdk.py --rinzu "$rinzu_cli" \
  --ui --require-gpu --sanitize --output "$sdk_reports/sdk.json"
python3 -B tests/integration/test_macos_gui.py --rinzu "$rinzu_cli" \
  --gpu --sample --sanitize --output "$sdk_reports/gui.json"
python3 -B tests/integration/test_macos_sheets.py --rinzu "$rinzu_cli" \
  --sanitize --return-cancel --output "$sdk_reports/sheets.json"
python3 -B tests/integration/test_macos_interrupt.py --rinzu "$rinzu_cli" --sanitize
```

The distribution check registers the public GitHub release asset in fresh applications. It checks the pinned checksum, offline restoration, the example packages, and matching output from JIT and moved, signed AOT app bundles.
