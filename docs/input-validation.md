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

Publication is held at the user's request. No v0.3.0 tag or release is created;
consumers use a locally committed development checkout. The stable public
release remains v0.2.0.

These SDK probes exercise real AppKit protocol implementations and synthetic
proposals. Human Japanese input-method, hardware keyboard and assistive
technology acceptance is recorded by the consuming application. Each run's
staged inputs, native binaries, module caches, bundles and reports inside its
isolated execution directory were removed on exit, including failed preflights.
Task-level qualification reports and the candidate archive are retained only
until local application integration finishes, then removed.
