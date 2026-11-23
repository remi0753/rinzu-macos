# rinzu.macos

AppKit, CoreText, and Metal SDK for Rinzu on Apple Silicon. It provides native windows and controls, owned events, async UI scopes, 2D drawing, GPU resources, and document and sheet APIs.

## Install

Use a macOS arm64 Rinzu toolchain with native SDK archive support. Run GUI applications from a desktop session. [v0.2.0 release](https://github.com/remi0753/rinzu-macos/releases/tag/v0.2.0)

From your application directory, register the module and refresh the native build lock.

```sh
rinzu modules add rinzu.macos https://github.com/remi0753/rinzu-macos/releases/download/v0.2.0/rinzu-macos-0.2.0.tar.gz
rinzu lock .
```

Use `import rinzu.macos;` in the application. Commit the manifest and `rinzu.modules.lock`, then use `rinzu modules sync` in other checkouts. Rinzu compiles the archived Objective-C sources with the local Xcode toolchain.

The examples in this SDK checkout use its sources for SDK development. Start with the [GUI guide](docs/guide.md), [API reference](docs/api.md), or [Metal example](examples/macos-metal/src/main.rinzu).

## Start and stop an application

application(title,width,height,body) owns the OS loop and invokes an async body receiving UiApplication. applicationWithSignals also registers cooperative process signals. Use app.primary for the initial UiScope and app.session for session-wide operations.

A scope owns its window, resources, and jobs. Dispatch owned UiEvent values in managed async handlers. Request stop when closing or quitting, stop intake, and await jobs/native/GPU completion before releasing their resources. Application shutdown is explicit; a native window does not become a transferable Worker value.

Session/Window/View and rendering resources are managed classes wrapping exported opaque handle types. Opaque handles have no methods or constructors and are used at the native ABI. Rect, Color, Event, and statistics are native scalar records with automatic writeback.

The low-level run handler has type fn(RunContext,Event)->Unit. RunContext is a language record containing session. Native code keeps the context through actual call/callback settlement and uses its checked fallback. Do not retain arbitrary managed callbacks outside supported call lifetimes.

The custom-view input API below is an unpublished v0.3.0 development candidate.
Use the qualified local checkout while publication is held; the stable v0.2.0
archive does not include this API.

## Controls and events

The [configuration guide](docs/guide.md#configure-application-controls)
covers window and activation policies, file and alert options, native text and
data settings, Canvas lifecycle, and recoverable event overflow.

The SDK includes labels, buttons, text fields/views, menus, checkboxes, layout helpers, accessibility, tooltips, themes, focus/scroll state, and owned window events. `windowOccluded` in `Window.state()` and
`eventWindowState.flags` reports AppKit occlusion separately from window visibility.
Occlusion-only transitions emit a state event, so applications can stop their own
work without polling. Keep application save/close policies in managed handlers. Programmatic state updates do not automatically reproduce user events.

Native views and Metal surfaces report raw key-down and key-up events. `UiEvent.text` owns the event's `NSEvent.characters` as UTF-8, including control characters and NUL. `keyCode` and `modifiers` retain the native values; `flags & keyRepeat` identifies repeats. The existing event queue limits apply to these snapshots. Applications interpret key meaning.

Custom drawn views can opt into `NSTextInputClient` with `View.publishInput`. An owned UTF-16 text and geometry projection supplies synchronous IME and accessibility queries. The SDK delivers marked text, replacement ranges, commits, commands, pointer and focus proposals as owned `eventInput` packets. The application owns editing, layout, authorization and routing. See the [custom input contract](docs/input.md).

List/table/tree DataView models use stable row IDs, columns, selection, expansion, sorting, and owned cell values. Dataset limits are 100000 rows, 32 columns, 16 MiB UTF-8 content, and tree depth 64. Generation yields every 256 rows and commits a completed model; failed or stopped updates discard uncommitted state. Serialize competing async operations on a view. These are bounded copied models, not remote paging or unbounded lists.

## Drawing and GPU resources

Metal APIs cover devices, buffers, textures, samplers, pipelines, compute/render commands, offscreen targets, uploads/readback, and asynchronous GPU completion. Resources must remain live through submitted work. Await physical completion before reuse or destroy.

`Command.drawTrianglesInstanced` accepts a vertex range, instance count and base instance.
Metal's instance ID includes that base; applications bound shader buffer indexing.
`pixelRGBA8Srgb` and `pixelBGRA8Srgb` provide four-byte, hardware sRGB decode/encode.
They support sampling/rendering, not shader writes. Upload/readback preserve stored
encoded bytes. Shaders supply linear RGB and the selected blend contract.
Use Texture.setAlphaMode to declare how uploaded colors represent alpha.
Batch2D.renderTexture produces premultiplied output and records that mode for
subsequent drawing. Its clear color uses linear RGB and straight alpha.
`View.setPixelFormat(pixelBGRA8Srgb)` also declares the layer's sRGB color space;
changes require no GPU lease. Defaults remain compatible with existing clients.

Textures support RGBA8/BGRA8 and single-byte R8/Alpha8 storage. Alpha8 samples coverage as premultiplied `(a,a,a,a)` for ordinary tinted drawing; it is not a render-target format. `Texture.readChannel` returns one tightly packed stored byte channel. `Font.metrics` exposes unrounded CoreText face and underline measurements in logical points.

Session.fontCatalog provides owned installed-face descriptors. Font.info reports the actual face, traits, matrices and variation axes; withTraits and withVariation derive real fonts. Font.shape exposes unrounded line advances and owned visual-order run/glyph/UTF-16 cluster data. TextLayout.fragment retains complete shaped clusters for independent rasterization, including fallback and color glyphs. Application segmentation, layout and cache policies stay in Rinzu. [Font and shaping guide](docs/guide.md#font-catalog-and-shaped-text)

Batch2D preserves draw order and batches compatible texture/filter/clip operations. Low-level coordinates are top-left drawable pixels. The managed canvas uses points with backing scale, and offers explicit pixel mode. Images are decoded/uploaded on Main. Text2D is a reusable shaped-text/texture snapshot; rebuild it when text changes.

Surface rendering admits only a drawable matching the captured pixel extent. `Command.beginRenderMatching` exposes that check; a size mismatch remains idle and unleased. Canvas jobs manage a surface, batch, frame waits, and cleanup. Invalidation coalesces requests. Idle/hidden/minimized/occluded views stop their frame timer; unavailable drawables use bounded backoff. `View.frameClock` keeps its Main RunLoop deadline contract. `View.displayClock`
uses the view's CADisplayLink on macOS 14+, capped by the screen and requested
maximum FPS, with deadline fallback on earlier systems. `FrameClock.timing`
identifies the active source and exposes native timestamps/period. Paused, idle
and hidden readers have no active display callback. Neither clock promises an
exact callback rate under system load.

## Documents and sheets

The document layer provides state, selection, undo/redo, snapshots, and explicit file saving. Await saves and resource users before closing. Open/save panels and alert sheets complete asynchronously; distinguish user cancellation from ordinary Error and runtime cancellation. Keep UI event and text ownership rules when composing IME or document callbacks.

## Bundled resources

session.resourceRoot returns Option<String> for application assets, or None in an ordinary JIT/console host. resourcePath validates a package-relative name and returns its bundled absolute path without reading it or changing cwd.

Use rinzu bundle to create an application from macos-app.json, then bundle-verify to inspect the generated inventory and ad-hoc signature. Keep the entire bundle together. Native OS-image compatibility still applies. Developer ID signing, notarization, and App Store submission are separate distribution steps.

See [AOT and bundle distribution](https://github.com/remi0753/rinzu/blob/v0.2.0/docs/tooling/distribution.md).

Local candidates can be checked before publishing with `test_macos_distribution.py --archive /path/to/candidate.tar.gz --sha256 DIGEST` using the installed toolchain. The same check covers archive integrity, offline restoration, JIT and relocated signed bundles.

## Compatibility and source provenance

| SDK tag  | Dependency                        | Rinzu                                     | Target      |
| -------- | --------------------------------- | ----------------------------------------- | ----------- |
| `v0.2.0` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.5` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.4` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.3` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.2` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.1` | Published module and SDK checkout | Verified with Rinzu `0.4.0`               | macOS arm64 |
| `v0.1.0` | Published module                  | Toolchain with native SDK archive support | macOS arm64 |
| `v0.1.0` | SDK checkout                      | Released Rinzu `0.3.0`                    | macOS arm64 |

The SDK, examples, and original test vectors come from the [Rinzu v0.2.0 source tree](https://github.com/remi0753/rinzu/tree/7aa3591af36cf4635f579a8d12803362dc48bff8/sdk/macos). The repository records upstream commit `7aa3591af36cf4635f579a8d12803362dc48bff8` as the extraction baseline.

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

## OS environment snapshots

`Session.observeEnvironment(true)` owns opt-in font, accessibility display,
screen-change and wake observers until disabled or the Session closes.
`eventEnvironment` carries a reason flag; `Session.environment()` is an owned
scalar snapshot with monotonically increasing font/environment generations and
current reduce-motion/transparency/contrast/color preferences. Notification
coalescing uses the ordinary bounded event queue. Late callbacks cannot re-open
a stopped owner. Font selection, rendering preferences and recovery policy belong
to the application.

A physically settled Metal surface can rebind to another Device in the same
Session with `View.setDevice`. Its view identity and frame reader remain stable.
`Device.isAvailable` exposes Metal's removal-request state. Clients recreate
their pipelines, buffers and textures; the SDK does not retain application caches.

The v0.2.0 API report flags one constructor change: Batch2D owns four additional
sRGB pipelines. Use `Device.batch2D` to acquire batches; existing factory calls,
legacy formats and examples remain supported. The new features are generic Metal
and OS environment bindings; application color, layout and scheduling policy stay
outside this SDK. [Validation](docs/rendering-validation.md)
