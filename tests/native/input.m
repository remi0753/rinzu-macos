// Generic custom-view input, UTF-16, AX and screen-coordinate contracts.
#include "../../native/src/macos.m"
#include <assert.h>
#include <stdio.h>

// A text system may flush a dead key and then request a command in one event.
@interface MixedInputContext : NSTextInputContext
@property(nonatomic, weak) RZMacNativeView *target;
@property(nonatomic) BOOL commitOnDeactivate;
@end
@implementation MixedInputContext
- (void)deactivate {
  if (self.commitOnDeactivate)
    [self.target insertText:@"late" replacementRange:NSMakeRange(NSNotFound, 0)];
  [super deactivate];
}
- (BOOL)handleEvent:(NSEvent *)event {
  (void)event;
  [self.target insertText:@"´" replacementRange:NSMakeRange(NSNotFound, 0)];
  [self.target doCommandBySelector:@selector(moveLeft:)];
  return YES;
}
@end

static NSDictionary *projection(int64_t epoch, int64_t revision, int64_t ack) {
  return @{
    @"version" : @1,
    @"epoch" : @(epoch),
    @"revision" : @(revision),
    @"ack" : @(ack),
    @"text" : @"A日😀\nB",
    @"selectedStart" : @0,
    @"selectedLength" : @1,
    @"inputStart" : @2,
    @"inputLength" : @0,
    @"markedStart" : @(-1),
    @"markedLength" : @0,
    @"caret" : @[ @40.0, @20.0, @1.0, @20.0 ],
    @"spans" : @[
      @[ @0, @1, @0.0, @0.0, @10.0, @20.0, @0 ], @[ @1, @1, @10.0, @0.0, @20.0, @20.0, @0 ],
      @[ @2, @2, @30.0, @0.0, @20.0, @20.0, @0 ], @[ @4, @1, @50.0, @0.0, @1.0, @20.0, @0 ],
      @[ @5, @1, @0.0, @20.0, @10.0, @20.0, @1 ]
    ],
    @"enabled" : @YES,
    @"focused" : @YES,
    @"raw" : @NO,
    @"rawModifiers" : @(NSEventModifierFlagControl | NSEventModifierFlagCommand),
    @"rawCodes" : @[ @36, @48, @51, @53, @123, @124, @125, @126 ]
  };
}
static int publish_projection(void *view, NSDictionary *value) {
  NSData *data = [NSJSONSerialization dataWithJSONObject:value options:0 error:NULL];
  return rinzu_macos_input_publish(view, data.bytes, data.length);
}
static void test_grid_spans(void) {
  NSMutableDictionary *value = [projection(1, 1, 0) mutableCopy];
  const struct RZInputSpan expected[] = {{{0, 1}, {{0, 0}, {10.4, 20}}, 0},
                                         {{1, 1}, {{10.4, 0}, {20, 20}}, 0},
                                         {{2, 2}, {{30.4, 0}, {20, 20}}, 0},
                                         {{4, 1}, {{50.4, 0}, {0, 20}}, 0},
                                         {{5, 1}, {{0, 20}, {10.4, 20.8}}, 1}};
  value[@"spans"] = @[];
  value[@"scale"] = @1.25;
  value[@"xEdges"] = @[ @0, @13, @25, @38, @50, @63 ];
  value[@"yEdges"] = @[ @0, @25, @51 ];
  value[@"lineSizes"] = @[ @8, @2 ];
  const uint8_t pairs[] = {1, 1, 1, 2, 2, 2, 1, 0, 1, 1};
  NSData *data = [NSData dataWithBytes:pairs length:sizeof(pairs)];
  NS_VALID_UNTIL_END_OF_SCOPE NSData *geometry = input_grid_spans(value, data);
  assert(geometry.length == sizeof(expected));
  const struct RZInputSpan *actual = geometry.bytes;
  for (NSUInteger index = 0; index < sizeof(expected) / sizeof(*expected); ++index) {
    assert(NSEqualRanges(actual[index].range, expected[index].range));
    assert(NSEqualRects(actual[index].rect, expected[index].rect));
    assert(actual[index].line == expected[index].line);
  }
  assert(NSEqualRanges(input_index_span(geometry, 3).range, NSMakeRange(2, 2)));
  assert(input_index_span(geometry, 6).range.location == NSNotFound);
  // A shorter transient composition can end at the next committed row's start.
  assert(input_first_rect_span(actual, 5, NSMakeRange(5, 0), 5) == 3);
  assert(input_first_rect_span(actual, 5, NSMakeRange(5, 0), 6) == 4);
  const uint8_t splitSurrogate[] = {1, 1, 1, 2, 1, 2, 2, 0, 1, 1};
  NSData *invalid = [NSData dataWithBytes:splitSurrogate length:sizeof(splitSurrogate)];
  assert(!input_grid_spans(value, invalid));
  value[@"lineSizes"] = @[ @6, @2 ];
  assert(!input_grid_spans(value, data));
  value[@"lineSizes"] = @[ @8, @2 ];
  value[@"xEdges"] = @[ @0, @13, @25, @38, @64, @63 ];
  assert(!input_grid_spans(value, data));
}
static NSDictionary *last_packet(RZMacSession *session) {
  int64_t sequence = session->sequence;
  NSData *data = session.payloads[@(sequence)];
  while (!data && sequence > 0)
    data = session.payloads[@(--sequence)];
  assert(data);
  NSDictionary *packet = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
  assert(packet && [packet[@"version"] intValue] == 1);
  return packet;
}
int main(void) {
  @autoreleasepool {
    test_grid_spans();
    void *session_raw = rinzu_macos_session(rinzu_macos_open());
    assert(session_raw);
    RZMacSession *session = (RZMacSession *)lookup(session_raw, RZ_SESSION);
    assert(rinzu_macos_prepare_events(session_raw) == 0);
    void *window_raw = rinzu_macos_window(
        rinzu_macos_window_create(session_raw, (const uint8_t *)"Generic input", 13, 360, 240));
    struct MacRect rect = {12, 18, 320, 200};
    void *view_raw = rinzu_macos_view(rinzu_macos_view_create(session_raw, &rect));
    assert(rinzu_macos_view_add(rinzu_macos_window_content(window_raw), view_raw) == 0);
    assert(rinzu_macos_window_show(window_raw) == 0);
    __block NSUInteger focus_attempts = 0;
    [NSTimer
        scheduledTimerWithTimeInterval:0.02
                               repeats:YES
                                 block:^(NSTimer *tick) {
                                   RZMacView *control = (RZMacView *)lookup(view_raw, RZ_VIEW);
                                   RZMacNativeView *view = (RZMacNativeView *)control.view;
                                   if (!view.window.isKeyWindow || !NSApp.active) {
                                     assert(++focus_attempts < 500);
                                     [view.window makeKeyAndOrderFront:nil];
                                     [NSApp activateIgnoringOtherApps:YES];
                                     return;
                                   }
                                   [tick invalidate];
                                   assert([view.window makeFirstResponder:view]);
                                   assert(publish_projection(view_raw, projection(1, 1, 0)) == 0);
                                   assert(view.inputActive && view.ownedInputContext);
                                   assert(rinzu_macos_view_cursor(view_raw, 2) == 0 &&
                                          view.explicitCursor == NSCursor.pointingHandCursor);
                                   assert(rinzu_macos_view_cursor(view_raw, 4) == RZ_ARGUMENT);
                                   assert(rinzu_macos_open_url(session_raw,
                                                               (const uint8_t *)"relative",
                                                               8) == RZ_ARGUMENT);
                                   struct MacRect unit = {0, 0, 1, 1}, backing = {0},
                                                  restored = {0};
                                   assert(rinzu_macos_view_convert(view_raw, &unit, &backing, 0) ==
                                          0);
                                   assert(rinzu_macos_view_convert(view_raw, &backing, &restored,
                                                                   1) == 0 &&
                                          restored.width == 1 && restored.height == 1);
                                   assert([view conformsToProtocol:@protocol(NSTextInputClient)]);
                                   assert([view.accessibilityRole
                                       isEqual:NSAccessibilityTextAreaRole]);
                                   assert([view.accessibilityValue isEqual:@"A日😀\nB"]);
                                   assert([view accessibilityNumberOfCharacters] == 6);
                                   assert(NSEqualRanges(view.selectedRange, NSMakeRange(2, 0)) &&
                                          NSEqualRanges(view.accessibilitySelectedTextRange,
                                                        NSMakeRange(0, 1)) &&
                                          [view.accessibilitySelectedText isEqual:@"A"]);
                                   assert(NSEqualRanges([view accessibilityRangeForIndex:3],
                                                        NSMakeRange(2, 2)));
                                   assert([view accessibilityLineForIndex:5] == 1);
                                   assert(NSEqualRanges([view accessibilityRangeForLine:0],
                                                        NSMakeRange(0, 5)));
                                   NSRange actual = NSMakeRange(NSNotFound, 0);
                                   NSRect first = [view firstRectForCharacterRange:NSMakeRange(1, 3)
                                                                       actualRange:&actual];
                                   assert(NSEqualRanges(actual, NSMakeRange(1, 3)) &&
                                          first.size.width == 40 && first.size.height == 20);
                                   NSRect collapsed =
                                       [view accessibilityFrameForRange:NSMakeRange(0, 0)];
                                   assert(collapsed.size.width == 0 &&
                                          fabs(collapsed.origin.x - first.origin.x + 10) < 0.01);
                                   assert([view characterIndexForPoint:NSMakePoint(
                                                                           NSMinX(first) + 1,
                                                                           NSMidY(first))] == 1);
                                   assert(NSEqualRanges(
                                       [view accessibilityRangeForPosition:NSMakePoint(
                                                                               NSMaxX(first) - 1,
                                                                               NSMidY(first))],
                                       NSMakeRange(2, 2)));
                                   NSRect before =
                                       [view firstRectForCharacterRange:NSMakeRange(2, 0)
                                                            actualRange:NULL];
                                   NSPoint origin = view.window.frame.origin;
                                   [view.window
                                       setFrameOrigin:NSMakePoint(origin.x + 37, origin.y + 23)];
                                   NSRect moved = [view firstRectForCharacterRange:NSMakeRange(2, 0)
                                                                       actualRange:NULL];
                                   assert(fabs(moved.origin.x - before.origin.x - 37) < 0.01 &&
                                          fabs(moved.origin.y - before.origin.y - 23) < 0.01);
                                   [view setMarkedText:@"かな😀"
                                          selectedRange:NSMakeRange(2, 2)
                                       replacementRange:NSMakeRange(NSNotFound, 0)];
                                   NSDictionary *marked = last_packet(session);
                                   assert([marked[@"kind"] intValue] == 3 &&
                                          [marked[@"epoch"] intValue] == 1 &&
                                          [marked[@"text"] isEqual:@"かな😀"]);
                                   assert([view.accessibilityValue isEqual:@"A日😀\nB"] &&
                                          [view.accessibilitySelectedText isEqual:@"A"]);
                                   assert(NSEqualRanges(view.markedRange, NSMakeRange(2, 4)) &&
                                          NSEqualRanges(view.selectedRange, NSMakeRange(4, 2)));
                                   NSAttributedString *substring =
                                       [view attributedSubstringForProposedRange:NSMakeRange(2, 2)
                                                                     actualRange:&actual];
                                   assert([substring.string isEqual:@"かな"]);
                                   [view insertText:@"仮名" replacementRange:NSMakeRange(2, 4)];
                                   NSDictionary *committed = last_packet(session);
                                   assert([committed[@"kind"] intValue] == 4 &&
                                          [committed[@"replacementStart"] intValue] == 2 &&
                                          [committed[@"replacementLength"] intValue] == 4 &&
                                          !view.hasMarkedText);
                                   [view setMarkedText:@"wxyz"
                                          selectedRange:NSMakeRange(4, 0)
                                       replacementRange:NSMakeRange(NSNotFound, 0)];
                                   [view setMarkedText:@"Q"
                                          selectedRange:NSMakeRange(1, 0)
                                       replacementRange:NSMakeRange(1, 2)];
                                   assert(NSEqualRanges(view.markedRange, NSMakeRange(1, 1)) &&
                                          NSEqualRanges(view.selectedRange, NSMakeRange(2, 0)));
                                   NSAttributedString *replaced =
                                       [view attributedSubstringForProposedRange:NSMakeRange(0, 5)
                                                                     actualRange:&actual];
                                   assert([replaced.string isEqual:@"AQxyz"] &&
                                          NSEqualRanges(actual, NSMakeRange(0, 5)) &&
                                          [view.accessibilityValue isEqual:@"A日😀\nB"]);
                                   [view unmarkText];
                                   [view setMarkedText:@"😀"
                                          selectedRange:NSMakeRange(1, 0)
                                       replacementRange:NSMakeRange(NSNotFound, 0)];
                                   assert([last_packet(session)[@"kind"] intValue] == 7);
                                   [view setMarkedText:@"取消"
                                          selectedRange:NSMakeRange(0, 2)
                                       replacementRange:NSMakeRange(NSNotFound, 0)];
                                   [view unmarkText];
                                   assert([last_packet(session)[@"kind"] intValue] == 5 &&
                                          !view.hasMarkedText);
                                   // A dead key may be pending without marked text.
                                   view.inputPending = YES;
                                   [view insertText:@"é"
                                       replacementRange:NSMakeRange(NSNotFound, 0)];
                                   assert([last_packet(session)[@"kind"] intValue] == 4 &&
                                          ([last_packet(session)[@"flags"] intValue] & 4) != 0 &&
                                          !view.inputPending);
                                   [view setAccessibilitySelectedTextRange:NSMakeRange(2, 2)];
                                   assert([last_packet(session)[@"kind"] intValue] == 13);
                                   MixedInputContext *context =
                                       [[MixedInputContext alloc] initWithClient:view];
                                   context.target = view;
                                   [view.ownedInputContext deactivate];
                                   view.ownedInputContext = context;
                                   NSMutableDictionary *mixed =
                                       [projection(1, 2, session->sequence) mutableCopy];
                                   mixed[@"rawCodes"] = @[];
                                   assert(publish_projection(view_raw, mixed) == 0);
                                   NSEvent *left =
                                       [NSEvent keyEventWithType:NSEventTypeKeyDown
                                                              location:NSZeroPoint
                                                         modifierFlags:0
                                                             timestamp:0
                                                          windowNumber:view.window.windowNumber
                                                               context:nil
                                                            characters:@"\uF702"
                                           charactersIgnoringModifiers:@"\uF702"
                                                             isARepeat:NO
                                                               keyCode:123];
                                   [view keyDown:left];
                                   NSDictionary *command = last_packet(session);
                                   assert([command[@"kind"] intValue] == 1 &&
                                          [command[@"command"] isEqual:@"moveLeft:"] &&
                                          !([command[@"flags"] intValue] & 2));
                                   int64_t before_release = session->sequence;
                                   [view keyUp:left];
                                   assert(session->sequence == before_release + 1 &&
                                          [last_packet(session)[@"kind"] intValue] == 2);
                                   context.commitOnDeactivate = YES;
                                   int64_t before_application_focus = session->sequence;
                                   [session applicationDidResignActive:
                                                [NSNotification
                                                    notificationWithName:
                                                        NSApplicationDidResignActiveNotification
                                                                  object:NSApp]];
                                   NSDictionary *application_lost = [NSJSONSerialization
                                       JSONObjectWithData:session.payloads[
                                                              @(before_application_focus + 1)]
                                                  options:0
                                                    error:NULL];
                                   assert([application_lost[@"kind"] intValue] == 12 &&
                                          [application_lost[@"flags"] intValue] == 0);
                                   [session applicationDidBecomeActive:
                                                [NSNotification
                                                    notificationWithName:
                                                        NSApplicationDidBecomeActiveNotification
                                                                  object:NSApp]];
                                   assert([last_packet(session)[@"kind"] intValue] == 12 &&
                                          ([last_packet(session)[@"flags"] intValue] & 2) != 0);
                                   int64_t before_focus = session->sequence;
                                   assert([view resignFirstResponder]);
                                   NSDictionary *lost = [NSJSONSerialization
                                       JSONObjectWithData:session.payloads[@(before_focus + 1)]
                                                  options:0
                                                    error:NULL];
                                   assert([lost[@"kind"] intValue] == 12 &&
                                          ([lost[@"flags"] intValue] & 1) == 0 &&
                                          [last_packet(session)[@"kind"] intValue] == 4);
                                   context.commitOnDeactivate = NO;
                                   [view syncInputContext];
                                   assert(view.inputActive && view.inputFocused);
                                   context.commitOnDeactivate = YES;
                                   int64_t before_window_blur = session->sequence;
                                   NSWindow *other = [[NSWindow alloc]
                                       initWithContentRect:NSMakeRect(80, 80, 100, 80)
                                                 styleMask:NSWindowStyleMaskTitled
                                                   backing:NSBackingStoreBuffered
                                                     defer:NO];
                                   other.releasedWhenClosed = NO;
                                   [other makeKeyAndOrderFront:nil];
                                   NSDictionary *window_lost = [NSJSONSerialization
                                       JSONObjectWithData:session
                                                              .payloads[@(before_window_blur + 1)]
                                                  options:0
                                                    error:NULL];
                                   assert(!view.inputActive && !view.inputFocused &&
                                          [window_lost[@"kind"] intValue] == 12 &&
                                          ([window_lost[@"flags"] intValue] & 1) == 0 &&
                                          [last_packet(session)[@"kind"] intValue] == 4);
                                   int64_t inactive_sequence = session->sequence;
                                   [view keyDown:left];
                                   assert(session->sequence == inactive_sequence);
                                   context.commitOnDeactivate = NO;
                                   NSDate *key_deadline = [NSDate dateWithTimeIntervalSinceNow:5];
                                   do {
                                     [view.window makeKeyAndOrderFront:nil];
                                     [NSApp activateIgnoringOtherApps:YES];
                                     [view.window makeFirstResponder:view];
                                     [[NSRunLoop currentRunLoop]
                                            runMode:NSDefaultRunLoopMode
                                         beforeDate:[NSDate dateWithTimeIntervalSinceNow:0.01]];
                                   } while (!view.isAccessibilityFocused &&
                                            key_deadline.timeIntervalSinceNow > 0);
                                   [other close];
                                   assert(view.inputActive && view.inputFocused &&
                                          [last_packet(session)[@"kind"] intValue] == 12 &&
                                          ([last_packet(session)[@"flags"] intValue] & 1) == 1);
                                   [view setHidden:YES];
                                   assert(!view.inputActive && !view.inputFocused);
                                   [view keyDown:left];
                                   [view setHidden:NO];
                                   [view.window makeFirstResponder:view];
                                   assert(view.inputActive && view.inputFocused);
                                   view.ownedInputContext = nil;
                                   view.inputActive = NO;
                                   unsigned before_motion = session->count;
                                   NSEvent *motion =
                                       [NSEvent mouseEventWithType:NSEventTypeMouseMoved
                                                          location:NSMakePoint(30, 30)
                                                     modifierFlags:0
                                                         timestamp:0
                                                      windowNumber:view.window.windowNumber
                                                           context:nil
                                                       eventNumber:0
                                                        clickCount:0
                                                          pressure:0];
                                   for (unsigned index = 0; index < 1000; ++index)
                                     [view mouseMoved:motion];
                                   assert(session->count <= before_motion + 1 &&
                                          [last_packet(session)[@"kind"] intValue] == 10);
                                   int64_t ack = session->sequence;
                                   assert(rinzu_macos_input_ack(view_raw, 1, ack) == 0);
                                   assert(rinzu_macos_input_ack(view_raw, 1, ack - 1) ==
                                          RZ_ARGUMENT);
                                   assert(publish_projection(view_raw, projection(1, 3, ack)) == 0);
                                   NSMutableDictionary *invalid =
                                       [projection(1, 4, ack) mutableCopy];
                                   invalid[@"selectedStart"] = @3;
                                   assert(publish_projection(view_raw, invalid) == RZ_ARGUMENT);
                                   assert(publish_projection(view_raw, projection(1, 1, ack)) ==
                                          RZ_ARGUMENT);
                                   assert(publish_projection(view_raw, projection(2, 4, ack)) == 0);
                                   struct MacInputState state = {0};
                                   assert(rinzu_macos_input_state(view_raw, &state) == 0 &&
                                          state.epoch == 2 && !state.composing);
                                   assert(rinzu_macos_input_detach(view_raw) == 0);
                                   assert(publish_projection(view_raw, projection(2, 5, ack)) ==
                                          RZ_ARGUMENT);
                                   assert(publish_projection(view_raw, projection(3, 5, ack)) == 0);
                                   assert(rinzu_macos_stop(session_raw) == 0);
                                 }];
    assert(rinzu_macos_run_events(session_raw) == 0);
    assert(rinzu_macos_window_destroy(window_raw) == 0);
    assert(rinzu_macos_prepare_close(session_raw) == 0);
    assert(rinzu_macos_close(session_raw) == 0);
    struct MacStatistics stats = {0};
    assert(rinzu_macos_statistics(&stats) == 0 && !stats.sessions && !stats.windows &&
           !stats.views && !stats.snapshotBytes && !stats.eventPayloadBytes &&
           !stats.retainedControls);
    puts("PASS: generic NSTextInputClient/AX snapshots, UTF-16, proposals, epochs, geometry and "
         "cleanup");
  }
  return 0;
}
