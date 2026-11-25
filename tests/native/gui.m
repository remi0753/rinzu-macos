// Real AppKit event-stream tests; private injection exercises snapshot lifetime.
#include "../../native/src/macos.m"
#include <assert.h>
#include <stdio.h>

static void clean(void) {
  struct MacStatistics stats = {0};
  assert(rinzu_macos_statistics(&stats) == 0);
  assert(!stats.sessions && !stats.windows && !stats.views && !stats.devices && !stats.commands &&
         !stats.buffers && !stats.retainedControls && !stats.queuedEvents &&
         !stats.eventPayloadBytes && !stats.snapshotBytes && !stats.libraries && !stats.pipelines);
}
static const uint8_t expected[] = {'A',  0,    0xf0, 0x9f, 0x98, 0x80,
                                   0xe6, 0x97, 0xa5, 0xe6, 0x9c, 0xac};
static struct MacEvent take_event(void *scope) {
  int64_t token = rinzu_macos_wait_token();
  assert(rinzu_macos_event_wait_begin(scope, token) == 0);
  struct MacEvent event;
  assert(rinzu_macos_event_take(scope, token, &event) == 1);
  assert(rinzu_macos_event_finish(scope, token) == 0);
  return event;
}

static void recovery(void) {
  void *scope = rinzu_macos_session(rinzu_macos_open());
  void *window = rinzu_macos_window(
      rinzu_macos_window_create(scope, (const uint8_t *)"Event recovery", 14, 240, 150));
  assert(window && rinzu_macos_event_overflow_recovery(scope, true) == 0);
  assert(rinzu_macos_prepare_events(scope) == 0);
  assert(rinzu_macos_event_overflow_recovery(scope, false) == RZ_BUSY);
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:0.01
                             repeats:NO
                               block:^(NSTimer *tick) {
                                 (void)tick;
                                 RZMacSession *owner = (RZMacSession *)lookup(scope, RZ_SESSION);
                                 [owner clearEvents];
                                 for (int64_t i = 0; i < RZ_EVENT_LIMIT + 4; ++i)
                                   [owner
                                       enqueue:(struct MacEvent){.kind = RZ_ACTION, .action = i}];
                                 assert(owner->count == RZ_EVENT_LIMIT && !owner.stopping);
                                 for (int64_t i = 0; i < RZ_EVENT_LIMIT - 1; ++i) {
                                   struct MacEvent event = take_event(scope);
                                   assert(event.kind == RZ_ACTION && event.action == i);
                                 }
                                 struct MacEvent loss = take_event(scope);
                                 assert(loss.kind == RZ_EVENT_OVERFLOW && loss.action == 5 &&
                                        !loss.windowId && !loss.viewId);
                                 [owner
                                     enqueue:(struct MacEvent){.kind = RZ_ACTION, .action = 999}];
                                 struct MacEvent next = take_event(scope);
                                 assert(next.kind == RZ_ACTION && next.action == 999 &&
                                        next.sequence > loss.sequence);
                                 assert(rinzu_macos_stop(scope) == 0);
                               }];
  assert(rinzu_macos_run_events(scope) == 0);
  [timer invalidate];
  assert(rinzu_macos_close(scope) == 0);
  clean();
  puts("PASS:gui-stream:recoverable-overflow:ordered-loss:resume:cleanup");
}

static void stream(BOOL overflow) {
  void *scope = rinzu_macos_session(rinzu_macos_open());
  void *window = rinzu_macos_window(
      rinzu_macos_window_create(scope, (const uint8_t *)"GUI stream", 10, 320, 200));
  assert(window);
  assert(rinzu_macos_prepare_events(scope) == 0);
  void *root = rinzu_macos_window_content(window);
  struct MacRect rect = {0, 0, 40, 20};
  void *child = rinzu_macos_view(rinzu_macos_view_create(scope, &rect));
  assert(rinzu_macos_view_add(root, child) == 0);
  assert(rinzu_macos_window_show(window) == 0);
  __block int stage = 0;
  __block int64_t pending = 0;
  __block unsigned ticks = 0;
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:0.002
                             repeats:YES
                               block:^(NSTimer *tick) {
                                 assert(++ticks < 1000);
                                 RZMacSession *owner = (RZMacSession *)lookup(scope, RZ_SESSION);
                                 assert(owner);
                                 if (stage == 3) {
                                   rinzu_native_completion_t *completion =
                                       rinzu_macos_event_completion(scope, pending);
                                   if (!rinzu_native_completion_is_done(completion))
                                     return;
                                   assert(rinzu_macos_event_finish(scope, pending) == 0);
                                   assert(rinzu_macos_event_bytes(scope, pending) == NULL);
                                   assert(rinzu_macos_stop(scope) == 0);
                                   [tick invalidate];
                                   stage = 4;
                                   return;
                                 }
                                 if (!owner->count)
                                   return;
                                 int64_t token = rinzu_macos_wait_token(),
                                         other = rinzu_macos_wait_token();
                                 assert(rinzu_macos_event_wait_begin(scope, token) == 0);
                                 assert(rinzu_macos_event_wait_begin(scope, other) == RZ_BUSY);
                                 assert(rinzu_macos_event_finish(scope, other) == RZ_BUSY);
                                 assert(rinzu_macos_prepare_close(scope) == RZ_BUSY);
                                 struct MacEvent event;
                                 assert(rinzu_macos_event_take(scope, token, &event) >= 0);
                                 if (event.kind == RZ_STARTED) {
                                   assert(stage == 0);
                                   // Layout can repeat while handling Resized. No-op
                                   // hierarchy / geometry must not create a feedback loop.
                                   unsigned before = owner->count;
                                   for (int index = 0; index < 1000; ++index) {
                                     assert(rinzu_macos_view_add(root, child) == 0);
                                     assert(rinzu_macos_view_set_frame(child, &rect) == 0);
                                     assert(rinzu_macos_window_size(window, 320, 200) == 0);
                                   }
                                   assert(owner->count == before && !owner.overflow);
                                   if (overflow) {
                                     NSData *text = [NSMutableData dataWithLength:RZ_TEXT_LIMIT];
                                     for (int index = 0; index < 9 && !owner.stopping; ++index) {
                                       void *item =
                                           rinzu_macos_view(rinzu_macos_view_create(scope, &rect));
                                       struct MacEvent change = {.kind = RZ_TEXT_CHANGED,
                                                                 .viewId =
                                                                     rinzu_macos_view_id(item)};
                                       [owner enqueue:change text:text];
                                     }
                                     assert(owner.overflow && owner.stopping);
                                     [tick invalidate];
                                   } else {
                                     NSMutableData *text =
                                         [NSMutableData dataWithBytes:expected
                                                               length:sizeof(expected)];
                                     struct MacEvent change = {.kind = RZ_SELECTION_CHANGED,
                                                               .windowId =
                                                                   rinzu_macos_window_id(window),
                                                               .viewId = rinzu_macos_view_id(child),
                                                               .selectionStart = 1,
                                                               .selectionEnd = 5};
                                     [owner enqueue:change text:text];
                                     change.kind = RZ_TEXT_CHANGED;
                                     [owner enqueue:change text:text];
                                     int64_t barrier = rinzu_macos_event_sequence(scope);
                                     unsigned queued = owner->count;
                                     [owner enqueue:change text:text];
                                     assert(owner->count == queued);
                                     assert(rinzu_macos_event_sequence(scope) > barrier);
                                     memset(text.mutableBytes, 0, text.length);
                                     stage = 1;
                                   }
                                 } else if (event.kind == RZ_TEXT_CHANGED) {
                                   assert(stage == 1 && event.selectionStart == 1 &&
                                          event.selectionEnd == 5);
                                   const rinzu_native_byte_array_t *bytes =
                                       rinzu_macos_event_bytes(scope, token);
                                   assert(bytes && bytes->length == sizeof(expected));
                                   assert(!memcmp(bytes->data, expected, sizeof(expected)));
                                   struct MacEvent stale = {.kind = RZ_TEXT_CHANGED,
                                                            .viewId = rinzu_macos_view_id(child)};
                                   [owner enqueue:stale
                                             text:[NSData dataWithBytes:expected
                                                                 length:sizeof(expected)]];
                                   assert(rinzu_macos_view_destroy(child) == 0);
                                   [owner enqueue:(struct MacEvent){.kind = RZ_ACTION,
                                                                    .viewId =
                                                                        rinzu_macos_view_id(root),
                                                                    .action = 99}];
                                   stage = 2;
                                 } else if (event.kind == RZ_ACTION) {
                                   assert(stage == 2 && event.action == 99);
                                   stage = 3;
                                 }
                                 assert(rinzu_macos_event_finish(scope, token) == 0);
                                 if (stage == 3) {
                                   assert(owner->count == 0 && owner.payloadBytes == 0);
                                   pending = rinzu_macos_wait_token();
                                   assert(rinzu_macos_event_wait_begin(scope, pending) == 0);
                                   rinzu_native_completion_t *completion =
                                       rinzu_macos_event_completion(scope, pending);
                                   assert(!rinzu_native_completion_is_done(completion));
                                   atomic_store_explicit(&completion->cancelled, 1,
                                                         memory_order_release);
                                 }
                               }];
  assert(rinzu_macos_run_events(scope) == (overflow ? RZ_OVERFLOW : 0));
  [timer invalidate];
  assert(overflow || stage == 4);
  assert(rinzu_macos_prepare_events(scope) == RZ_BUSY);
  assert(rinzu_macos_run_events(scope) == RZ_BUSY);
  assert(rinzu_macos_prepare_close(scope) == 0);
  assert(rinzu_macos_close(scope) == 0);
  clean();
  puts(overflow ? "PASS:gui-stream:bounded-payload-overflow:cleanup"
                : "PASS:gui-stream:owned-unicode-nul:stale:reader-cancel:cleanup");
}
static void widgets(void) {
  void *scope = rinzu_macos_session(rinzu_macos_open());
  int64_t first = rinzu_macos_wait_token(), second = rinzu_macos_wait_token();
  void *window = rinzu_macos_window(
      rinzu_macos_window_scoped(scope, first, (const uint8_t *)"Widgets", 7, 520, 360));
  NSRect screen = NSScreen.mainScreen.visibleFrame;
  struct MacRect initial = {NSMinX(screen) + 32, NSMinY(screen) + 48, 320, 200};
  NSWindowStyleMask style = NSWindowStyleMaskTitled | NSWindowStyleMaskClosable;
  void *other = rinzu_macos_window(rinzu_macos_window_configured(
      scope, second, (const uint8_t *)"Other", 5, &initial, style, false, false));
  assert(window && other);
  RZMacWindow *configured = (RZMacWindow *)lookup(other, RZ_WINDOW);
  assert(configured.window.styleMask == style && !configured.activateOnShow);
  NSRect positioned = [configured.window contentRectForFrameRect:configured.window.frame];
  if (!NSEqualRects(positioned, nsrect(&initial)))
    fprintf(stderr, "configured window frame %s, expected %s\n",
            NSStringFromRect(positioned).UTF8String, NSStringFromRect(nsrect(&initial)).UTF8String);
  assert(NSEqualRects(positioned, nsrect(&initial)));
  void *root = rinzu_macos_window_content(window);
  struct MacRect frame = {10, 10, 240, 100};
  void *items[6];
  for (int kind = 1; kind <= 6; ++kind) {
    items[kind - 1] =
        rinzu_macos_view(rinzu_macos_widget_scoped(window, kind, expected, sizeof(expected), &frame,
                                                   kind == RZ_BUTTON     ? 10
                                                   : kind == RZ_CHECKBOX ? 11
                                                                         : 0));
    assert(items[kind - 1]);
    if (kind != RZ_TEXT_VIEW)
      assert(rinzu_macos_view_add(root, items[kind - 1]) == 0);
  }
  void *text = items[RZ_TEXT_VIEW - 1];
  assert(rinzu_macos_text_view_options(text, NULL, 0, 18, 2 | 4 | 16) == 0);
  NSTextView *configured_editor = (NSTextView *)((RZMacView *)lookup(text, RZ_VIEW)).view;
  assert(configured_editor.font.pointSize == 18 && configured_editor.allowsUndo &&
         configured_editor.automaticQuoteSubstitutionEnabled &&
         configured_editor.automaticTextReplacementEnabled &&
         !configured_editor.automaticDashSubstitutionEnabled);
  assert(rinzu_macos_scroll_content(items[RZ_SCROLL_VIEW - 1], text) == 0);
  assert(rinzu_macos_scroll_content(items[RZ_SCROLL_VIEW - 1], root) == RZ_ARGUMENT);
  assert(rinzu_macos_view_focus(text) == 0);
  NSString *original = [configured_editor.string copy];
  NSUndoManager *history = configured_editor.undoManager;
  assert(history);
  history.groupsByEvent = NO;
  [history beginUndoGrouping];
  [configured_editor insertText:@"!" replacementRange:NSMakeRange(original.length, 0)];
  [configured_editor breakUndoCoalescing];
  [history endUndoGrouping];
  NSString *edited = [original stringByAppendingString:@"!"];
  assert([configured_editor.string isEqualToString:edited] && history.canUndo);
  assert(rinzu_macos_window_command(window, 5) == 0);
  assert([configured_editor.string isEqualToString:original] && history.canRedo);
  assert(rinzu_macos_window_command(window, 6) == 0);
  assert([configured_editor.string isEqualToString:edited]);
  assert(rinzu_macos_window_command(window, 5) == 0);
  assert([configured_editor.string isEqualToString:original]);
  assert(rinzu_macos_text_view_options(text, NULL, 0, 13, 1) == 0);
  int64_t snapshot = rinzu_macos_wait_token(), wrong = rinzu_macos_wait_token();
  assert(rinzu_macos_widget_snapshot(text, snapshot) == 0);
  assert(rinzu_macos_widget_snapshot(text, wrong) == RZ_BUSY);
  assert(rinzu_macos_widget_snapshot_finish(text, wrong) == RZ_BUSY);
  assert(rinzu_macos_view_destroy(text) == RZ_BUSY);
  assert(rinzu_macos_window_scope_close(scope, first) == RZ_BUSY);
  assert(rinzu_macos_close(scope) == RZ_BUSY);
  assert(rinzu_macos_widget_set_text(text, (const uint8_t *)"changed", 7) == 0);
  const rinzu_native_byte_array_t *bytes = rinzu_macos_widget_bytes(text, snapshot);
  assert(bytes && bytes->length == sizeof(expected) &&
         !memcmp(bytes->data, expected, sizeof(expected)));
  assert(rinzu_macos_widget_snapshot_finish(text, snapshot) == 0);
  assert(rinzu_macos_widget_set_text(text, expected, sizeof(expected)) == 0);
  assert(rinzu_macos_text_select(text, 2, 5) == 0);
  struct MacSelection selection;
  assert(rinzu_macos_text_selection(text, &selection) == 0);
  assert(selection.start == 2 && selection.end == 5);
  assert(rinzu_macos_text_select(text, -1, 0) == RZ_ARGUMENT);
  assert(rinzu_macos_text_select(text, 6, 6) == RZ_ARGUMENT);
  assert(rinzu_macos_widget_set_text(root, expected, sizeof(expected)) == RZ_ARGUMENT);
  assert(rinzu_macos_widget_value(items[RZ_CHECKBOX - 1], 1) == 0);
  struct MacWidgetState state;
  assert(rinzu_macos_widget_state(items[RZ_CHECKBOX - 1], &state) == 0 && state.value == 1);
  assert(rinzu_macos_widget_value(items[RZ_BUTTON - 1], 1) == RZ_ARGUMENT);
  assert(rinzu_macos_view_enabled(items[RZ_BUTTON - 1], false) == 0);
  assert(rinzu_macos_widget_state(items[RZ_BUTTON - 1], &state) == 0 && !state.enabled);
  assert(rinzu_macos_view_enabled(items[RZ_BUTTON - 1], true) == 0);
  assert(rinzu_macos_window_show(window) == 0);
  // Each TextField receives a bounded field editor without replacing AppKit's delegate.
  assert(rinzu_macos_view_focus(items[RZ_TEXT_FIELD - 1]) == 0);
  RZMacView *field = (RZMacView *)lookup(items[RZ_TEXT_FIELD - 1], RZ_VIEW);
  NSTextView *fieldEditor = text_editor(field);
  assert(fieldEditor == field.fieldEditor);
  NSString *large = [@"x" stringByPaddingToLength:RZ_TEXT_LIMIT + 1
                                       withString:@"x"
                                  startingAtIndex:0];
  [fieldEditor insertText:large replacementRange:NSMakeRange(0, fieldEditor.string.length)];
  assert([fieldEditor.string lengthOfBytesUsingEncoding:NSUTF8StringEncoding] <= RZ_TEXT_LIMIT);
  [fieldEditor insertText:@"日" replacementRange:NSMakeRange(0, 0)];
  assert([fieldEditor.string hasPrefix:@"日"]);
  assert(rinzu_macos_view_focus(text) == 0);
  RZMacView *editor = (RZMacView *)lookup(text, RZ_VIEW);
  NSTextView *nativeText = (NSTextView *)editor.view;
  [nativeText setMarkedText:@"仮"
              selectedRange:NSMakeRange(1, 0)
           replacementRange:NSMakeRange(0, 0)];
  assert(nativeText.hasMarkedText);
  assert(rinzu_macos_widget_set_text(text, (const uint8_t *)"replacement", 11) == RZ_BUSY);
  [nativeText unmarkText];
  assert(rinzu_macos_widget_set_text(text, expected, sizeof(expected)) == 0);
  __block int actions = 0, edits = 0, fieldEdits = 0;
  __block BOOL injected = NO, entered = NO;
  __block unsigned ticks = 0;
  NSButton *button = (NSButton *)((RZMacView *)lookup(items[RZ_BUTTON - 1], RZ_VIEW)).view;
  NSButton *checkbox = (NSButton *)((RZMacView *)lookup(items[RZ_CHECKBOX - 1], RZ_VIEW)).view;
  void *fieldRaw = items[RZ_TEXT_FIELD - 1];
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:0.002
                             repeats:YES
                               block:^(NSTimer *tick) {
                                 if (entered)
                                   return;
                                 entered = YES;
                                 assert(++ticks < 1000);
                                 RZMacSession *owner = (RZMacSession *)lookup(scope, RZ_SESSION);
                                 if (!owner->count) {
                                   entered = NO;
                                   return;
                                 }
                                 int64_t token = rinzu_macos_wait_token();
                                 assert(rinzu_macos_event_wait_begin(scope, token) == 0);
                                 struct MacEvent event;
                                 assert(rinzu_macos_event_take(scope, token, &event) >= 0);
                                 if (event.kind == RZ_STARTED && !injected) {
                                   injected = YES;
                                   [button performClick:nil];
                                   [checkbox performClick:nil];
                                   [nativeText insertText:@"!" replacementRange:NSMakeRange(0, 0)];
                                   assert(rinzu_macos_view_focus(fieldRaw) == 0);
                                   [text_editor(field) insertText:@"?"
                                                 replacementRange:NSMakeRange(0, 0)];
                                   unsigned before = owner->count;
                                   assert(rinzu_macos_widget_set_text(
                                              text, (const uint8_t *)"newer", 5) == 0);
                                   assert(owner->count == before);
                                 } else if (event.kind == RZ_ACTION &&
                                            (event.action == 10 || event.action == 11)) {
                                   ++actions;
                                 } else if (event.kind == RZ_TEXT_CHANGED &&
                                            event.viewId == rinzu_macos_view_id(text)) {
                                   const rinzu_native_byte_array_t *snapshot =
                                       rinzu_macos_event_bytes(scope, token);
                                   assert(snapshot && snapshot->length == sizeof(expected) + 1 &&
                                          snapshot->data[0] == '!');
                                   assert(!memcmp(snapshot->data + 1, expected, sizeof(expected)));
                                   ++edits;
                                 } else if (event.kind == RZ_TEXT_CHANGED &&
                                            event.viewId == rinzu_macos_view_id(fieldRaw)) {
                                   const rinzu_native_byte_array_t *snapshot =
                                       rinzu_macos_event_bytes(scope, token);
                                   assert(snapshot && snapshot->length >= 1 &&
                                          snapshot->data[0] == '?');
                                   ++fieldEdits;
                                 }
                                 assert(rinzu_macos_event_finish(scope, token) == 0);
                                 if (actions == 2 && edits == 1 && fieldEdits == 1) {
                                   assert(rinzu_macos_stop(scope) == 0);
                                   [tick invalidate];
                                 }
                                 entered = NO;
                               }];
  assert(rinzu_macos_run_events(scope) == 0);
  [timer invalidate];
  assert(actions == 2 && edits == 1 && fieldEdits == 1);
  // Removing a View preserves its Window resource scope until explicitly moved.
  assert(rinzu_macos_view_remove(items[RZ_LABEL - 1]) == 0);
  assert(rinzu_macos_window_scope_prepare(scope, first) == 0);
  assert(rinzu_macos_widget_scoped(window, RZ_LABEL, NULL, 0, &frame, 0) == RZ_BUSY);
  assert(rinzu_macos_window_scope_close(scope, first) == 0);
  assert(rinzu_macos_view_id(items[RZ_LABEL - 1]) == RZ_INVALID);
  assert(rinzu_macos_window_id(other) > 0);
  assert(rinzu_macos_window_scope_close(scope, first) == 0);
  assert(rinzu_macos_window_scope_close(scope, second) == 0);
  assert(rinzu_macos_prepare_close(scope) == 0);
  assert(rinzu_macos_close(scope) == 0);
  clean();
  puts("PASS:gui-widgets:snapshot:unicode:composition:actions:window-scopes:cleanup");
}
static void menus(void) {
  void *scope = rinzu_macos_session(rinzu_macos_open());
  RZMacSession *owner = (RZMacSession *)lookup(scope, RZ_SESSION);
  owner.pasteboard = [NSPasteboard pasteboardWithUniqueName];
  assert(rinzu_macos_clipboard_write(scope, expected, sizeof(expected)) == 0);
  int64_t snapshot = rinzu_macos_wait_token(), wrong = rinzu_macos_wait_token();
  assert(rinzu_macos_clipboard_snapshot(scope, snapshot) == 0);
  assert(rinzu_macos_clipboard_snapshot(scope, wrong) == RZ_BUSY);
  assert(rinzu_macos_clipboard_finish(scope, wrong) == RZ_BUSY);
  assert(rinzu_macos_prepare_close(scope) == RZ_BUSY);
  assert(rinzu_macos_close(scope) == RZ_BUSY);
  assert(rinzu_macos_clipboard_write(scope, (const uint8_t *)"new", 3) == 0);
  const rinzu_native_byte_array_t *bytes = rinzu_macos_clipboard_bytes(scope, snapshot);
  assert(bytes && bytes->length == sizeof(expected) &&
         !memcmp(bytes->data, expected, sizeof(expected)));
  assert(rinzu_macos_clipboard_finish(scope, snapshot) == 0);
  assert(!rinzu_macos_clipboard_bytes(scope, snapshot));
  void *window =
      rinzu_macos_window(rinzu_macos_window_create(scope, (const uint8_t *)"Menus", 5, 320, 200));
  void *other =
      rinzu_macos_window(rinzu_macos_window_create(scope, (const uint8_t *)"Other", 5, 320, 200));
  void *bar = rinzu_macos_menu(rinzu_macos_menu_create(window, (const uint8_t *)"Main", 4));
  void *file = rinzu_macos_menu(rinzu_macos_menu_create(window, (const uint8_t *)"File", 4));
  void *edit = rinzu_macos_menu(rinzu_macos_menu_create(window, (const uint8_t *)"Edit", 4));
  assert(bar && file && edit);
  assert(rinzu_macos_menu_submenu(bar, file) == 0);
  assert(rinzu_macos_menu_submenu(file, bar) == RZ_ARGUMENT);
  assert(rinzu_macos_menu_submenu(bar, edit) == 0);
  assert(rinzu_macos_window_menu(window, file) == RZ_ARGUMENT);
  assert(rinzu_macos_window_menu(other, bar) == RZ_ARGUMENT);
  assert(rinzu_macos_menu_item(file, (const uint8_t *)"Save", 4, (const uint8_t *)"s", 1,
                               NSEventModifierFlagCommand, 500, 0) == 0);
  assert(rinzu_macos_menu_item(file, (const uint8_t *)"Duplicate", 9, NULL, 0, 0, 500, 0) ==
         RZ_ARGUMENT);
  assert(rinzu_macos_menu_separator(file) == 0);
  assert(rinzu_macos_menu_item(edit, (const uint8_t *)"Select All", 10, (const uint8_t *)"a", 1,
                               NSEventModifierFlagCommand, 0, 4) == 0);
  assert(rinzu_macos_menu_state(file, 500, false, true) == 0);
  NSMenuItem *save = [((RZMacMenu *)lookup(file, RZ_MENU)).menu itemAtIndex:0];
  assert(!save.enabled && save.state == NSControlStateValueOn);
  assert(rinzu_macos_menu_state(file, 500, true, false) == 0);
  assert(rinzu_macos_window_menu(window, bar) == 0);
  struct MacRect frame = {12, 12, 280, 160};
  void *text = rinzu_macos_view(
      rinzu_macos_widget_scoped(window, RZ_TEXT_VIEW, expected, sizeof(expected), &frame, 0));
  assert(rinzu_macos_view_add(rinzu_macos_window_content(window), text) == 0);
  assert(rinzu_macos_view_autoresizing(text, 18) == 0);
  assert(rinzu_macos_view_autoresizing(text, 64) == RZ_ARGUMENT);
  assert(rinzu_macos_window_size(window, 400, 240) == 0);
  struct MacRect resized;
  assert(rinzu_macos_view_frame(text, &resized) == 0);
  assert(resized.width == 360 && resized.height == 200);
  NSMenu *previous = [NSMenu new];
  NSApp.mainMenu = previous;
  assert(rinzu_macos_window_show(window) == 0);
  assert(rinzu_macos_view_focus(text) == 0);
  __block int commands = 0;
  __block unsigned ticks = 0;
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:0.002
                             repeats:YES
                               block:^(NSTimer *tick) {
                                 assert(++ticks < 1000);
                                 if (!owner->count)
                                   return;
                                 int64_t token = rinzu_macos_wait_token();
                                 assert(rinzu_macos_event_wait_begin(scope, token) == 0);
                                 struct MacEvent event;
                                 assert(rinzu_macos_event_take(scope, token, &event) >= 0);
                                 if (event.kind == RZ_STARTED) {
                                   assert(NSApp.mainMenu ==
                                          ((RZMacMenu *)lookup(bar, RZ_MENU)).menu);
                                   NSEvent *key =
                                       [NSEvent keyEventWithType:NSEventTypeKeyDown
                                                              location:NSZeroPoint
                                                         modifierFlags:NSEventModifierFlagCommand
                                                             timestamp:0
                                                          windowNumber:0
                                                               context:nil
                                                            characters:@"s"
                                           charactersIgnoringModifiers:@"s"
                                                             isARepeat:NO
                                                               keyCode:1];
                                   assert([NSApp.mainMenu performKeyEquivalent:key]);
                                   assert(rinzu_macos_window_command(window, 4) == 0);
                                   struct MacSelection selected;
                                   assert(rinzu_macos_text_selection(text, &selected) == 0 &&
                                          selected.start == 0 && selected.end == 5);
                                   assert(rinzu_macos_window_command(window, 5) == 0);
                                 } else if (event.kind == RZ_ACTION && event.action == 500) {
                                   assert(event.windowId == rinzu_macos_window_id(window) &&
                                          event.viewId == 0);
                                   ++commands;
                                 } else if (event.kind == RZ_ACTION && event.action == -1) {
                                   ++commands;
                                 }
                                 assert(rinzu_macos_event_finish(scope, token) == 0);
                                 if (commands == 2) {
                                   assert(rinzu_macos_stop(scope) == 0);
                                   [tick invalidate];
                                 }
                               }];
  assert(rinzu_macos_run_events(scope) == 0);
  [timer invalidate];
  assert(commands == 2 && NSApp.mainMenu == previous);
  assert(rinzu_macos_window_destroy(window) == 0);
  assert(rinzu_macos_menu_destroy(file) == RZ_INVALID);
  assert(rinzu_macos_window_id(other) > 0);
  [owner.pasteboard releaseGlobally];
  assert(rinzu_macos_close(scope) == 0);
  clean();
  puts("PASS:gui-menu:shortcut:command:window-scope:clipboard-snapshot:autoresize:cleanup");
}
static void keys(void) {
  void *scope = rinzu_macos_session(rinzu_macos_open());
  void *window = rinzu_macos_window(
      rinzu_macos_window_create(scope, (const uint8_t *)"Key snapshots", 13, 320, 200));
  struct MacRect rect = {0, 0, 200, 100};
  void *child = rinzu_macos_view(rinzu_macos_view_create(scope, &rect));
  assert(rinzu_macos_view_add(rinzu_macos_window_content(window), child) == 0);
  assert(rinzu_macos_prepare_events(scope) == 0);
  assert(rinzu_macos_window_show(window) == 0);
  assert(rinzu_macos_view_focus(child) == 0);
  unichar nul = 0;
  NSArray<NSString *> *samples = @[
    @"x", @"日😀", @"日😀", [NSString stringWithCharacters:&nul length:1], @"\003", @"", @"owned"
  ];
  __block NSUInteger seen = 0;
  __block unsigned ticks = 0;
  NSTimer *timer = [NSTimer
      scheduledTimerWithTimeInterval:0.002
                             repeats:YES
                               block:^(NSTimer *tick) {
                                 assert(++ticks < 1000);
                                 RZMacSession *owner = (RZMacSession *)lookup(scope, RZ_SESSION);
                                 if (!owner->count)
                                   return;
                                 int64_t token = rinzu_macos_wait_token();
                                 assert(rinzu_macos_event_wait_begin(scope, token) == 0);
                                 struct MacEvent event;
                                 assert(rinzu_macos_event_take(scope, token, &event) >= 0);
                                 if (event.kind == RZ_STARTED) {
                                   RZMacView *view = (RZMacView *)lookup(child, RZ_VIEW);
                                   for (NSUInteger index = 0; index < samples.count; ++index) {
                                     NSMutableString *characters = [samples[index] mutableCopy];
                                     NSEventModifierFlags modifiers =
                                         index == 1 ? NSEventModifierFlagShift
                                                    : (index == 3 || index == 4
                                                           ? NSEventModifierFlagControl
                                                           : 0);
                                     NSEvent *key = [NSEvent
                                                    keyEventWithType:index == 2 ? NSEventTypeKeyUp
                                                                                : NSEventTypeKeyDown
                                                            location:NSZeroPoint
                                                       modifierFlags:modifiers
                                                           timestamp:0
                                                        windowNumber:0
                                                             context:nil
                                                          characters:characters
                                         charactersIgnoringModifiers:characters
                                                           isARepeat:index == 1 || index == 6
                                                             keyCode:(unsigned short)(7 + index)];
                                     if (index == 2)
                                       [view.view keyUp:key];
                                     else
                                       [view.view keyDown:key];
                                     [characters setString:@"changed after enqueue"];
                                   }
                                 } else if (event.kind == RZ_KEY_DOWN || event.kind == RZ_KEY_UP) {
                                   assert(seen < samples.count);
                                   assert(event.kind == (seen == 2 ? RZ_KEY_UP : RZ_KEY_DOWN));
                                   assert(event.windowId == rinzu_macos_window_id(window));
                                   assert(event.viewId == rinzu_macos_view_id(child) &&
                                          event.keyCode == 7 + (int64_t)seen);
                                   assert(event.flags == (seen == 1 || seen == 6 ? 1 : 0));
                                   NSEventModifierFlags modifiers =
                                       seen == 1
                                           ? NSEventModifierFlagShift
                                           : (seen == 3 || seen == 4 ? NSEventModifierFlagControl
                                                                     : 0);
                                   assert(event.modifiers == (int64_t)modifiers);
                                   NSData *expected_text =
                                       [samples[seen] dataUsingEncoding:NSUTF8StringEncoding];
                                   const rinzu_native_byte_array_t *bytes =
                                       rinzu_macos_event_bytes(scope, token);
                                   assert(bytes && bytes->length == expected_text.length);
                                   assert(!bytes->length ||
                                          !memcmp(bytes->data, expected_text.bytes, bytes->length));
                                   ++seen;
                                 }
                                 assert(rinzu_macos_event_finish(scope, token) == 0);
                                 assert(rinzu_macos_event_bytes(scope, token) == NULL);
                                 if (seen == samples.count) {
                                   assert(rinzu_macos_stop(scope) == 0);
                                   [tick invalidate];
                                 }
                               }];
  assert(rinzu_macos_run_events(scope) == 0);
  [timer invalidate];
  assert(seen == samples.count);
  assert(rinzu_macos_close(scope) == 0);
  clean();
  puts("PASS:gui-keys:owned-utf8-nul:up-down:modifiers:repeat:fifo:cleanup");
}

int main(int argc, char **argv) {
  assert(argc == 2);
  @autoreleasepool {
    if (!strcmp(argv[1], "keys"))
      keys();
    else if (!strcmp(argv[1], "menus"))
      menus();
    else if (!strcmp(argv[1], "widgets"))
      widgets();
    else if (!strcmp(argv[1], "overflow-recovery"))
      recovery();
    else
      stream(!strcmp(argv[1], "overflow"));
  }
  return 0;
}
