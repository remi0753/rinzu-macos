# macOS applications and GUI

Register the published SDK from your application directory using the [installation instructions](../README.md#install).

The public API covers Session, Window, View, widgets, owned events, async application handlers, Metal resources, 2D drawing, documents, and sheets. [The SDK reference](../README.md) describes the application entry and resource types; [the source](../src/macos.rinzu) contains exact signatures.

## A minimal window

Create an application package and add this `src/main.rinzu`. It displays a label and requests a clean stop when the user closes the window or quits.

```rinzu
import rinzu.macos;

async fn screen(app: rinzu.macos.UiApplication) {
    let scope = app.primary;
    let label = scope.label("Hello, Rinzu!", rinzu.macos.Rect(x: 20.0, y: 20.0, width: 300.0, height: 30.0));
    let root = scope.window.contentView();
    let added = root.addSubview(label.view);
    await scope.dispatch(
        async fn (owner: rinzu.macos.UiScope, event: rinzu.macos.UiEvent) {
            if event.kind == rinzu.macos.eventCloseRequested || event.kind == rinzu.macos.eventQuitRequested {
                owner.requestStop();
            }
        }
    );
}

async fn main() {
    try {
        let status = await rinzu.macos.applicationWithSignals("My App", 480.0, 320.0, screen);
    }
    catch problems {
        panic("application failed");
    }
}
```

```sh
rinzu check ./my-app
rinzu run ./my-app
```

This example needs a desktop session when run; checking it does not open a window.

## Application ownership

The application session and its windows run on physical Main. Use the high-level application scope to associate UI resources and managed jobs with the application lifecycle. Stop event intake, await active handlers and GPU/native completion, then release resources. Background tasks cannot receive UI handles through Worker transfer.

The low-level run handler is synchronous and receives a RunContext containing a session. Native code retains that context through the actual call and callback settlement. Build asynchronous application behavior using the SDK's managed handler layer rather than storing arbitrary managed closures in native code.

## Choose an API layer

| Feature         | Public concepts                                                              |
| --------------- | ---------------------------------------------------------------------------- |
| Native controls | Window, View, buttons, text controls, layout, accessibility, themes          |
| Data views      | List/table/tree DataView, stable row IDs, columns, selection and sort events |
| Text editing    | Document state, undo/redo, selection, snapshots and file saving              |
| Sheets          | Open/save panels and alerts with asynchronous completion                     |
| GPU             | Device, buffers, textures, samplers, pipelines, command submission and waits |
| 2D drawing      | Batch2D, images, shaped text, canvas jobs, frame clocks                      |

Data models are bounded: datasets have at most 100000 rows, 32 columns, and 16 MiB of UTF-8 cell data; trees have at most 64 levels. Updates yield during generation and commit the complete model. Serialize competing async updates to one view in application code.

Batch2D preserves draw order while batching compatible texture/filter/clip state. Surface rendering checks the captured pixel extent against the admitted drawable; a resize mismatch is retryable and holds no command or surface lease. Canvas2D obtains fresh frame geometry and retries. Low-level callers can use `Command.beginRenderMatching` for the same admission check.

Low-level batch coordinates use drawable pixels; the high-level canvas uses points and backing scale. A FrameClock schedules Main RunLoop deadlines; it does not promise display-link synchronization or exact frame rates.

## One-channel images and font metrics

`pixelR8` stores one byte per pixel and samples the standard Metal red channel.
`pixelAlpha8` also uses R8Unorm storage and samples coverage as `(a,a,a,a)`.
The alpha format works with ordinary premultiplied `Batch2D.imageRegion` tinting;
it supports sampled/storage usage, while custom R8 render targets use `pixelR8`.
`Texture.info().bytes` and native texture statistics count one byte per R8/Alpha8
pixel and four bytes per RGBA8/BGRA8 pixel. Upload stride and readback use that
stored channel count; an R8 row need not have four-byte alignment.

`Texture.readChannel(region, channel)` returns one tightly packed stored byte
channel as owned bytes. Indices follow storage order: RGBA and BGRA each allow
0 through 3, while R8 and Alpha8 allow only 0. Reads and uploads require no GPU
lease. Sampling swizzles do not change stored bytes or channel indices.

`Font.metrics()` returns unrounded CoreText ascent, descent, leading, underline
position and thickness in logical font points, plus the face's units per em.
Applications choose their own layout grid, shaping policy and cache identity.

## Font catalog and shaped text

`Session.fontCatalog()` returns an owned descriptor snapshot; applications select
fonts and define refresh/cache policy. `Font.info()` reports the actual PostScript
face, size, matrix, bold/italic/monospaced/color traits and supported variation axes
with active values. `withTraits(0..3)` resolves real bold/italic faces and fails when
unavailable; `withVariation(identifier, value)` derives a face within a supported
axis range. No synthetic style or application-specific fallback policy is imposed.

`Font.shape(text, ligatures)` makes one immutable, unwrapped CoreText line.
`TextLayout.shaping()` exposes visual-order runs, the actual fallback face and
text matrix, direction, glyph IDs, positions/advances and half-open UTF-16 source
cluster ranges. Source indices are neither scalar nor grapheme nor application
layout indices. Glyph ID zero remains observable as a missing glyph. Ligature
control uses CoreText's standard ligature attribute; required script shaping is
preserved when optional ligatures are disabled.

`TextLayout.fragment(start, end)` retains the original line and selects complete
clusters. It rejects surrogate/cluster splits and recursive fragment selection.
The fragment's X origin is the first selected glyph's position; Y is the baseline
(`metrics.baseline = 0`). Raster bounds include ink and padding, independent of
logical advance. A fragment survives its source layout, and raster textures survive
both. Fonts stay busy until all dependent layouts/fragments retire. Snapshots are
managed owned values and survive native handle destruction.

Input is limited to 64 KiB, advance to 8192 points, runs to 4096, glyphs to 65536,
axes per face to 64, catalog faces to 16384 and each encoded snapshot to 16 MiB.
These handles retain Session/Main affinity. Applications own segmentation, layout,
bidirectional presentation, cell mapping, cache identities and eviction. The SDK
only calls CoreText and rasterizes the selected native glyphs.

## Resource access and application bundles

Create `macos-app.json` in an application package:

```json
{
  "schema": "rinzu.macos-app-v1",
  "identifier": "dev.example.myapp",
  "name": "My App",
  "version": "0.1.0",
  "build": "1",
  "resources": ["assets"]
}
```

```sh
rinzu bundle ./my-app --output './My App.app'
rinzu bundle-verify './My App.app'
```

Bundle creation does not execute the application's Main. Resources use package-relative paths and cannot be symlinks. The optional icon accepts a 1024×1024 PNG or a supported ICNS file.

`session.resourceRoot()` returns Option<String> for bundled application resources and None in an ordinary JIT/console host. `session.resourcePath("assets/title.txt")` validates a relative resource name and returns its absolute bundled path; it does not read the file or change cwd. Select a development path when running without a bundle.

See [Distribution](https://github.com/remi0753/rinzu/blob/v0.3.0/docs/tooling/distribution.md) for sidecars, signatures, relocation, and native OS compatibility requirements.
