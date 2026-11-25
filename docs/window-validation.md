# Window and text input validation

## v0.4.0 release validation

The release adds window placement, display enumeration, fullscreen controls,
AppKit tab groups, and draggable dividers. Text views support selectable
read-only text and contextual key bindings for editing, movement, and the find
bar. Window live-resize previews and transparent Metal surfaces are opt-in.

The SDK regression suite passed 33 Rinzu test cases and 104 native tests,
including ASan, UBSan, and TSan. Integration checks covered Source JIT and AOT,
resource acquisition and cancellation, live AppKit IME and sheet results,
example applications, and signal and interrupt handling. The Rinzu test
discovery checks used a source-built toolchain.

The API comparison with v0.3.0 reports 54 additions and flags two changes for
review. Direct `UiScope` construction now requires `ownsWindow`. Applications
can get a scope from `app.primary`, a `withWindow` or `withWindowOptions`
callback, or `OwnedWindow.scope`. The `Document` change is an internal
dependency fingerprint.

The reproducible nine-file archive was verified with the published Rinzu
v0.4.0 macOS arm64 toolchain. Distribution checks cover module registration,
SHA-256 locking, offline restoration, all eight examples, relocated ad-hoc
signed AOT application bundles, and rejection of modified bundle assets.

Archive SHA-256 is
`0785c28a8c613db8e2afc85e9a1d6cd17cda1dabed3d39d52a58184c92d8f538`.
