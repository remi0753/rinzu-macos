# Rendering and environment validation — 2026-11-22

Rinzu 0.4.0 on macOS arm64 qualified the generic instance draw, four-byte sRGB
textures/surfaces, owned environment notifications, settled surface Device
rebinding and display-paced frame clock. No terminal algorithm is part of this SDK.

All 99 owned files passed formatting and checks before executable tests. The
native suite, Source JIT/AOT matrix, GUI/scope/graphics acquisition suite, sheets,
sanitizers and signal-inheritance/interrupt modes passed. Notification tests cover
1,000 coalesced font changes, current accessibility preferences, owner rejection,
observer removal and late notification after close. Render tests cover instance
base/range errors, sRGB sample decode/linear blend/encoded readback, physical GPU
leases and Device rebinding. Existing deadline clocks remain supported.

A separate Rinzu real-window fixture presented 120 frames per runtime through
CADisplayLink at 60 Hz. Median interval was 16.667 ms; p95 absolute jitter from
16.667 ms was 0.140 ms in JIT and 0.071 ms in AOT. Maximum observed intervals
were 37.857/33.351 ms. Idle/hidden callbacks and final native/runtime resources
were zero; resume produced a fresh frame. These are SDK clear/present timings,
not application workload guarantees. A 120 Hz screen was unavailable.

The exact deterministic eight-file module archive passed registration, SHA-256,
offline restore, all eight examples, JIT and relocated signed AOT bundles and
asset-tamper rejection. SHA-256: `938ba4adea3770e7f9374f07cdc9a09f6ab2b168e207ac3b3aaf30dcb77c51e0`.
The API comparison reports one breaking candidate for Batch2D's generated
constructor because it owns additional pipelines. Existing Device.batch2D
factory calls and the unchanged examples passed. This is a v0.2.0 release.

One sheets preflight used `/private/tmp` while AppKit returned its `/tmp` alias.
The unchanged fixture passed with the same temporary root's `/tmp` spelling.
Every run, including that preflight, removed all copied inputs, outputs, caches,
reports and logs in its isolated workspace. Task-level tools/reports are removed
when the application integration finishes.
