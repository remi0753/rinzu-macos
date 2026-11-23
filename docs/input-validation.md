# Custom input validation — 2026-11-22

The v0.3.0 candidate adds generic custom-view input and AX projections. Native
code only bridges AppKit, owns bounded event data and answers synchronous OS
queries. Application editing, keyboard protocols, selection, permission and
terminal behavior remain outside this SDK.

All owned files were formatted and checked before executable tests. The native
suite passed 49 cases without skips, including real windows, Metal and
ASan/UBSan. The new input probe covers UTF-16 and surrogate boundaries, IME
proposal metadata, marked/commit/cancel, a dead-key flush followed by a command, a pending dead key without marked text,
key-up without text reinterpretation, responder and window focus-loss ordering,
hidden-view rejection, focus recovery, application deactivation while a sheet
owns focus, activation flags and loss-before-input-context ordering, motion
coalescing,
epoch and ack rejection, independent text-system and AX selections,
AX cluster/line/point queries, window movement,
backing coordinates and complete resource release. The input probe also passed
with ASan/UBSan.

The source core check/build and JIT/AOT runs passed, including InputSnapshot,
InputState, coordinate round trips and detach. The public API comparison against
v0.2.0 found 15 additions and zero breaking candidates; this is not a proof of
behavioral equivalence.

The deterministic nine-file archive passed module registration, SHA-256 checks,
offline restoration, all eight unchanged examples, JIT and relocated signed
AOT bundles, and modified-asset rejection. Archive SHA-256:
`e9dd3ebe214c4022a269902037bdafeaa13e38c981ed2f7382d7b8ba797ff382`.

This checksum identifies a development snapshot. See
[v0.3.0 release validation](#v030-release-validation) for the published archive.

These SDK probes exercise real AppKit protocol implementations and synthetic
proposals. Human Japanese input-method, hardware keyboard and assistive
technology acceptance is recorded by the consuming application. Each run's
staged inputs, native binaries, module caches, bundles and reports inside its
isolated execution directory were removed on exit, including failed preflights.
Task-level qualification reports and the candidate archive are retained only
until local application integration finishes, then removed.

## Rinzu snapshot encoding follow-up (2026-11-22)

`encodeInputSnapshot` is available beside `decodeInputPacket` for preparing and
inspecting the generic input wire format without a View. `View.publishInput`
uses that same encoder. Numeric span fragments are assembled in Rinzu instead
of allocating a JSON value tree for every span. User text and snapshot metadata
retain the JSON encoder. Finite geometry, 32,768 spans, UTF-8 and 8 MiB wire
limits are preserved; no native implementation changed.

The source core passed JIT and AOT with exact fractional/extreme/signed finite
coordinates, escaped CJK/emoji text, empty spans, non-finite rejection and span
count bounds. All 49 native cases passed without skips, including actual
windows, Metal and ASan/UBSan. The public comparison against v0.2.0 reports 16
additions and no breaking candidates. The eight unchanged examples and archive
registration, offline, moved signed AOT and tamper checks passed. The updated
nine-file candidate archive SHA-256 is
`fa87e91154232c8bdb6f4d66e9aa4866025df68f33cabce34c7e345d3410b1d9`.
This checksum identifies the snapshot-encoding follow-up.

### Bounded span fragments

The initial flat fragment List passed functional qualification but regressed
encoding time. A separate AOT comparison with identical snapshots measured
medians of 8 / 50 ms for the original JSON-tree encoder at 2,369 / 7,742 spans,
30 / 346 ms for the flat fragment prototype, and 4 / 13 ms with bounded groups
of 64 fragments. Every decoded output matched the original. Completed groups
are concatenated once, bounding repeated immutable-list prefix copies.

The grouped implementation passed the source core JIT/AOT precision and bounds
checks, API comparison, eight unchanged examples and local distribution probes.
Its nine-file archive SHA-256 is
`47cbf303c5c2d1e862617346b4f52562063435a1337c1731dc356a692a4cfcb4`.
The native implementation and its qualified 49 cases are unchanged. These
measurements cover SDK snapshot encoding.

## v0.3.0 release validation

The release adds custom-view input and accessibility snapshots, application and
control options, display-paced Canvas configuration, and opt-in recovery from
event overflow. The SDK regression tests cover session ownership, IME replacement
ranges, sRGB compositing, document save state, Undo and Redo, and data-view events.

The release qualification covers AppKit and Metal on macOS arm64, Source JIT and
AOT, GUI and sheets, ASan and UBSan, and signal inheritance and interrupts.
The nine-file archive was checked with the released Rinzu v0.4.0 toolchain for
module installation, checksum locking, offline restoration, all eight examples,
relocated signed AOT bundles, and rejection of modified bundle assets.

The SDK tests use real AppKit interfaces with synthetic input and accessibility
proposals. Applications validate operator input and assistive technology with
their own workflows.

Archive SHA-256 is
`da468d630a6fe075d3111d6d5d91a93e21ac52ece74bb486f27b86188d3e2223`.
