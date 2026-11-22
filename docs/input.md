# Input for custom drawn views

Publish an `InputSnapshot` on a native view or Metal surface. Its text, UTF-16
selection and marked range, caret and cluster spans answer synchronous
`NSTextInputClient` and accessibility queries. Coordinates are logical points
with a top-left view origin. The SDK converts candidate rectangles to screen
coordinates, including window movement and backing scale. Cluster spans carry
visual line indices and never split surrogate pairs.

`View.inputPacket(event)` decodes an owned `eventInput`. The packet preserves the
capture epoch, native key code, modifiers, repeat and interpreted flags, input
source, original event type, command selector, replacement/selection ranges and
pointer coordinates, buttons, precision and momentum. Kinds are documented on
`InputPacket`. A key interpreted by the text system must not also be inserted
as raw text. An explicit command can accompany a dead-key flush in one event.

The application serializes proposals, applies its editing policy, and publishes
a new snapshot. The native marked shadow exists only to answer synchronous OS
queries before that publication; it does not edit the application's model.
`ack` is the last consumed `UiEvent.sequence`; `View.acknowledgeInput` advances
it without copying unchanged text. Unacknowledged composition mutations are
not overwritten by older application snapshots. Snapshot revisions, acks and
epochs must advance monotonically. Reusing a detached epoch is rejected.

Set `enabled` false or advance the epoch to revoke pending input. Detach before
releasing an application model. `discardMarkedText` discards OS composition
without inventing a commit. Focus changes are proposals too. Raw key codes and
modifier masks are application configuration and do not bypass an active or
pending input-method composition. Omitting a snapshot preserves legacy raw
key events and their existing ABI.

AX text, UTF-16 cluster and visual-line ranges, point queries, selection and
focus use the same projection. Changes post value, selection and focus
notifications. AX selection changes are proposals for the application to
validate. The SDK does not implement an editor, terminal protocol, clipboard
permission or URL policy. `Session.openURL` dispatches an absolute URL only;
applications validate the scheme and user gesture before calling it.

Limits are 1 MiB of UTF-8 snapshot text, 32,768 nonoverlapping cluster spans,
8 MiB of encoded snapshot data, 256 raw key codes, and 64 KiB for each input
text field. Invalid UTF-16 boundaries, conflicting revisions, oversized
snapshots and nonfinite geometry fail explicitly. An oversized native input
proposal becomes an overflow packet. Applications define recovery and must
not replay stale or duplicate proposals.

`tests/input.m` exercises actual AppKit protocol queries, native proposals,
UTF-16 clusters, dead-key-plus-command dispatch, screen-coordinate movement,
epoch revocation and resource cleanup. The source core fixture exercises the
managed API in JIT and AOT. Human input-method and assistive-technology
acceptance belongs to each application's own qualification.

Apple's contracts: [NSTextInputClient](https://developer.apple.com/documentation/appkit/nstextinputclient),
[marked text](https://developer.apple.com/documentation/appkit/nstextinputclient/setmarkedtext%28_%3Aselectedrange%3Areplacementrange%3A%29),
[candidate rectangle](https://developer.apple.com/documentation/appkit/nstextinputclient/firstrect%28forcharacterrange%3Aactualrange%3A%29).
