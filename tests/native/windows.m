#include "../../native/src/macos.m"
#include <assert.h>
#include <stdio.h>

static NSEvent *key_event(NSWindow *window, NSString *key, unsigned short code,
                          NSEventModifierFlags modifiers) {
  return [NSEvent keyEventWithType:NSEventTypeKeyDown
                          location:NSZeroPoint
                     modifierFlags:modifiers
                         timestamp:NSProcessInfo.processInfo.systemUptime
                      windowNumber:window.windowNumber
                           context:nil
                        characters:key
       charactersIgnoringModifiers:key
                         isARepeat:NO
                           keyCode:code];
}

static void exercise_text_keys(void *session, void *window) {
  assert(rinzu_macos_window_show(window) == 0);
  void *root = rinzu_macos_window_content(window);
  const struct MacRect frame = {0, 0, 380, 220};
  NSMutableString *document = [NSMutableString stringWithString:@"# sample\n\nwidth = 10\n"];
  for (NSUInteger line = 0; line < 24; ++line)
    [document appendString:@"# More settings\n"];
  NSData *contents = [document dataUsingEncoding:NSUTF8StringEncoding];
  void *scroll =
      rinzu_macos_view(rinzu_macos_widget_scoped(window, RZ_SCROLL_VIEW, NULL, 0, &frame, 0));
  void *text = rinzu_macos_view(
      rinzu_macos_widget_scoped(window, RZ_TEXT_VIEW, contents.bytes, contents.length, &frame, 0));
  assert(scroll && text && rinzu_macos_view_add(root, scroll) == 0);
  assert(rinzu_macos_scroll_content(scroll, text) == 0);
  RZMacWindow *control = (RZMacWindow *)lookup(window, RZ_WINDOW);
  NSTextView *editor = (NSTextView *)((RZMacView *)lookup(text, RZ_VIEW)).view;
  RZMacSession *owner = (RZMacSession *)lookup(session, RZ_SESSION);
  assert(editor.frame.size.height > frame.height);

  const char keys[] = "[[\"a\",0,1,2,15],[\"\\u001b\",0,2,3,16],[\"/\",0,1,12,0],"
                      "[\"\\u001b\",0,3,13,0],[\"s\",1048576,0,0,17],"
                      "[\"j\",0,1,5,0],[\"k\",0,1,6,0]]";
  const int64_t options = RZ_KEY_BLOCK_CARET | RZ_KEY_CONSUME_READ_ONLY | RZ_KEY_ENABLE_FIND;
  assert(rinzu_macos_text_view_keys(text, (const uint8_t *)keys, sizeof(keys) - 1, options) == 0);
  const char duplicate[] = "[[\"a\",0,1,2,15],[\"a\",0,1,1,0]]";
  assert(rinzu_macos_text_view_keys(text, (const uint8_t *)duplicate, sizeof(duplicate) - 1,
                                    options) == RZ_ARGUMENT);
  assert(rinzu_macos_view_focus(text) == 0);
  assert(rinzu_macos_text_view_is_editable(text) == 1);
  assert(rinzu_macos_text_select(text, 0, 0) == 0);
  assert(rinzu_macos_text_view_editable(text, NO) == 0);
  assert(rinzu_macos_text_view_is_editable(text) == 0);
  assert(editor.selectedRange.location == 0 && editor.selectedRange.length == 1);
  assert(rinzu_macos_view_enabled(text, NO) == 0);
  assert(rinzu_macos_view_enabled(text, YES) == 0);
  assert(rinzu_macos_text_view_is_editable(text) == 0);

  [NSApp sendEvent:key_event(control.window, @"j", 38, 0)];
  assert(NSEqualRanges(editor.selectedRange, NSMakeRange(9, 0)));
  [NSApp sendEvent:key_event(control.window, @"j", 38, 0)];
  assert(NSEqualRanges(editor.selectedRange, NSMakeRange(10, 1)));
  [NSApp sendEvent:key_event(control.window, @"k", 40, 0)];
  assert(NSEqualRanges(editor.selectedRange, NSMakeRange(9, 0)));
  [NSApp sendEvent:key_event(control.window, @"k", 40, 0)];
  assert(NSEqualRanges(editor.selectedRange, NSMakeRange(0, 1)));
  assert(!editor.editable && [editor.string isEqualToString:document]);

  [NSApp sendEvent:key_event(control.window, @"a", 0, 0)];
  assert(rinzu_macos_text_view_is_editable(text) == 1);
  [NSApp sendEvent:key_event(control.window, @"x", 7, 0)];
  assert([editor.string hasPrefix:@"#x "]);
  [editor setMarkedText:@"あ"
          selectedRange:NSMakeRange(1, 0)
       replacementRange:NSMakeRange(NSNotFound, 0)];
  assert(editor.hasMarkedText);
  assert(!route_text_key(control, key_event(control.window, @"\x1b", 53, 0)));
  [editor unmarkText];

  [NSApp sendEvent:key_event(control.window, @"\x1b", 53, 0)];
  assert(rinzu_macos_text_view_is_editable(text) == 0);
  [NSApp sendEvent:key_event(control.window, @"/", 44, 0)];
  assert(editor.enclosingScrollView.findBarVisible);
  [NSApp sendEvent:key_event(control.window, @"\x1b", 53, 0)];
  assert(!editor.enclosingScrollView.findBarVisible && control.window.firstResponder == editor);
  [owner clearEvents];
  [NSApp sendEvent:key_event(control.window, @"s", 1, NSEventModifierFlagCommand)];
  assert(owner->count == 1 && owner->events[owner->head].kind == RZ_ACTION &&
         owner->events[owner->head].viewId == rinzu_macos_view_id(text) &&
         owner->events[owner->head].action == 17);
  assert(rinzu_macos_view_destroy(scroll) == 0 && control.textKeyView == nil);
}

static void exercise_live_resize(void *session, void *window) {
  RZMacWindow *control = (RZMacWindow *)lookup(window, RZ_WINDOW);
  RZMacSession *owner = (RZMacSession *)lookup(session, RZ_SESSION);
  NSSize initial = control.window.contentView.bounds.size;
  void *device = rinzu_macos_device(rinzu_macos_device_create(session));
  const struct MacRect frame = {0, 0, initial.width, initial.height};
  void *surface = rinzu_macos_view(rinzu_macos_surface_scoped(device, window, &frame));
  assert(surface && rinzu_macos_view_add(rinzu_macos_window_content(window), surface) == 0);
  assert(rinzu_macos_view_autoresizing(surface, NSViewWidthSizable | NSViewHeightSizable) == 0);
  RZMacView *view = (RZMacView *)lookup(surface, RZ_VIEW);
  CAMetalLayer *layer = view.metalLayer;
  CGSize drawable = layer.drawableSize;
  assert(drawable.width > 0 && drawable.height > 0);

  assert(rinzu_macos_window_live_resize_preview(window, YES) == 0);
  const struct MacColor background = {0.13, 0.24, 0.36, 0.5};
  assert(rinzu_macos_surface_live_resize_background(surface, &background) == 0);
  assert(view.view.layer.masksToBounds && view.resizeRight && view.resizeBelow);
  [owner clearEvents];
  [control
      windowWillStartLiveResize:[NSNotification
                                    notificationWithName:NSWindowWillStartLiveResizeNotification
                                                  object:control.window]];
  for (int step = 1; step <= 140; ++step) {
    [control.window setContentSize:NSMakeSize(initial.width + step, initial.height + step)];
    assert(NSEqualSizes(view.view.frame.size, control.window.contentView.bounds.size));
    assert(CGSizeEqualToSize(layer.drawableSize, drawable));
    assert(CGRectEqualToRect(layer.frame, CGRectMake(0, step, initial.width, initial.height)));
    assert(CGRectEqualToRect(view.resizeRight.frame,
                             CGRectMake(initial.width, 0, step, initial.height + step)));
    assert(CGRectEqualToRect(view.resizeBelow.frame, CGRectMake(0, 0, initial.width, step)));
    assert(CGColorGetAlpha(view.resizeRight.backgroundColor) == 0.5 &&
           CGColorGetAlpha(view.resizeBelow.backgroundColor) == 0.5);
  }
  [control.window setContentSize:NSMakeSize(initial.width - 30, initial.height - 20)];
  assert(CGRectEqualToRect(layer.frame, CGRectMake(0, -20, initial.width, initial.height)));
  assert(CGRectIsEmpty(view.resizeRight.frame) && CGRectIsEmpty(view.resizeBelow.frame));
  assert(!owner.overflow);
  for (unsigned index = 0; index < owner->count; ++index) {
    int kind = owner->events[(owner->head + index) % RZ_EVENT_LIMIT].kind;
    assert(kind != RZ_RESIZED && kind != RZ_DRAW && kind != RZ_WINDOW_PLACEMENT);
  }

  [control windowDidEndLiveResize:[NSNotification
                                      notificationWithName:NSWindowDidEndLiveResizeNotification
                                                    object:control.window]];
  NSSize expected = [view.view convertRectToBacking:view.view.bounds].size;
  assert(CGSizeEqualToSize(layer.drawableSize, expected) &&
         !CGSizeEqualToSize(layer.drawableSize, drawable));
  assert(CGSizeEqualToSize(layer.bounds.size, initial));
  BOOL rootResized = NO;
  BOOL surfaceResized = NO;
  for (unsigned index = 0; index < owner->count; ++index) {
    struct MacEvent event = owner->events[(owner->head + index) % RZ_EVENT_LIMIT];
    if (event.kind == RZ_RESIZED) {
      rootResized |= event.viewId == control.content.identity;
      surfaceResized |= event.viewId == view.identity;
    }
  }
  assert(rootResized && surfaceResized);

  void *gpu = rinzu_macos_command(rinzu_macos_command_create(device));
  assert(gpu && rinzu_macos_command_render_matching(gpu, surface, &background, expected.width,
                                                    expected.height) == 0);
  assert(rinzu_macos_command_commit(gpu) == 0);
  RZMacCommand *command = (RZMacCommand *)lookup(gpu, RZ_COMMAND);
  [command.command waitUntilCompleted];
  int64_t token = rinzu_macos_wait_token();
  assert(rinzu_macos_command_wait_begin(gpu, token) == 0);
  assert(rinzu_macos_command_status(gpu) == 0);
  assert(rinzu_macos_command_finish(gpu, token) == 0);
  assert(rinzu_macos_command_destroy(gpu) == 0);
  assert(!view.holdingResizeContents && NSEqualSizes(layer.frame.size, view.view.bounds.size));

  [control.window setContentSize:initial];
  assert(CGSizeEqualToSize(layer.drawableSize, drawable));
  assert(rinzu_macos_window_live_resize_preview(window, NO) == 0);
  assert(rinzu_macos_view_destroy(surface) == 0);
  assert(rinzu_macos_device_destroy(device) == 0);
}

static void exercise_transparency(void *session, void *window) {
  RZMacWindow *control = (RZMacWindow *)lookup(window, RZ_WINDOW);
  NSColor *background = control.window.backgroundColor;
  BOOL opaque = control.window.opaque;
  assert(rinzu_macos_window_transparent_background(window, YES) == 0);
  assert(rinzu_macos_window_transparent_background(window, YES) == 0);
  assert(!control.window.opaque && control.window.backgroundColor.alphaComponent == 0.0);

  void *root = rinzu_macos_window_content(window);
  assert(rinzu_macos_surface_opaque(root, NO) == RZ_ARGUMENT);
  if (rinzu_macos_metal_available()) {
    void *device = rinzu_macos_device(rinzu_macos_device_create(session));
    const struct MacRect frame = {0, 0, 40, 40};
    void *surface = rinzu_macos_view(rinzu_macos_surface_scoped(device, window, &frame));
    assert(surface && rinzu_macos_view_add(root, surface) == 0);
    CAMetalLayer *layer = (CAMetalLayer *)((RZMacView *)lookup(surface, RZ_VIEW)).view.layer;
    assert(rinzu_macos_surface_opaque(surface, NO) == 0 && !layer.opaque);
    assert(rinzu_macos_surface_opaque(surface, YES) == 0 && layer.opaque);
    assert(rinzu_macos_view_destroy(surface) == 0);
    assert(rinzu_macos_device_destroy(device) == 0);
  }
  assert(rinzu_macos_window_transparent_background(window, NO) == 0);
  assert(control.window.opaque == opaque && [control.window.backgroundColor isEqual:background]);
}

static void exercise(void *session, void *first) {
  void *second = rinzu_macos_window(
      rinzu_macos_window_create(session, (const uint8_t *)"Second", 6, 460, 280));
  assert(second);
  int64_t anchor = rinzu_macos_window_id(first);
  assert(rinzu_macos_window_tab_identity(first, anchor) == 0);
  assert(rinzu_macos_window_tab_identity(second, anchor) == 0);
  assert(rinzu_macos_window_tab_attach(first, first) == RZ_ARGUMENT);
  assert(rinzu_macos_window_tab_attach(first, second) == 0);
  assert(rinzu_macos_window_tab_attach(first, second) == 0);
  assert(rinzu_macos_window_tab_select(second) == 0);
  struct MacWindowTabs initial, selected;
  assert(rinzu_macos_window_tabs(first, &initial) == 0);
  assert(rinzu_macos_window_tabs(second, &selected) == 0);
  assert(initial.count == 2 && initial.first == selected.first);
  assert(selected.selected == rinzu_macos_window_id(second));
  assert(initial.index != selected.index);
  assert(rinzu_macos_window_state(first) & 64);

  assert(rinzu_macos_window_tab_color(second, 0x4268a3) == 0);
  RZMacWindow *child = (RZMacWindow *)lookup(second, RZ_WINDOW);
  assert(child.window.tab.accessoryView != nil);
  assert(rinzu_macos_window_tab_color(second, -1) == 0);
  assert(child.window.tab.accessoryView == nil);

  RZMacSession *owner = (RZMacSession *)lookup(session, RZ_SESSION);
  NSWindow *target = child.window;
  struct MacRect frame;
  assert(rinzu_macos_window_frame(second, &frame) == 0);
  struct MacRect moved = frame;
  moved.x += 11;
  moved.y += 7;
  [owner clearEvents];
  assert(rinzu_macos_window_set_frame(second, &moved) == 0);
  assert(rinzu_macos_window_frame(second, &frame) == 0);
  assert(fabs(frame.x - moved.x) < 1 && fabs(frame.y - moved.y) < 1);
  if (rinzu_macos_display_count(session) > 0) {
    struct MacDisplay display;
    assert(rinzu_macos_display_at(session, 0, &display) == 0);
    assert(display.identifier > 0 && display.width > 0 && display.height > 0);
  }
  assert(rinzu_macos_display_at(session, -1, NULL) == RZ_ARGUMENT);

  void *root = rinzu_macos_window_content(second);
  int64_t identity = rinzu_macos_divider_create(second, YES);
  void *divider = rinzu_macos_view(identity);
  assert(divider && rinzu_macos_view_add(root, divider) == 0);
  assert(rinzu_macos_view_set_frame(divider, &(struct MacRect){100, 0, 7, 220}) == 0);
  [owner clearEvents];
  RZMacView *view = (RZMacView *)lookup(divider, RZ_VIEW);
  NSPoint local = NSMakePoint(180, 23);
  NSPoint point = [target.contentView convertPoint:local toView:nil];
  NSEvent *drag = [NSEvent mouseEventWithType:NSEventTypeLeftMouseDragged
                                     location:point
                                modifierFlags:0
                                    timestamp:0
                                 windowNumber:target.windowNumber
                                      context:nil
                                  eventNumber:0
                                   clickCount:1
                                     pressure:1.0];
  [view.view mouseDragged:drag];
  assert(owner->count == 1);
  struct MacEvent delivery = owner->events[owner->head];
  assert(delivery.kind == RZ_DIVIDER && delivery.viewId == identity && delivery.x == local.x &&
         delivery.y == local.y);
  assert(rinzu_macos_view_destroy(divider) == 0);

  void *menu = rinzu_macos_menu(rinzu_macos_menu_create(first, (const uint8_t *)"Main", 4));
  assert(menu && rinzu_macos_application_menu(session, menu) == 0);
  [owner clearEvents];
  assert(![owner applicationShouldHandleReopen:NSApp hasVisibleWindows:NO]);
  assert(owner->count == 1 && owner->events[owner->head].kind == RZ_REOPEN);

  assert(rinzu_macos_window_tab_detach(second) == 0);
  assert(rinzu_macos_window_tabs(first, &initial) == 0 && initial.count == 1);
  assert(rinzu_macos_window_tabs(second, &selected) == 0 && selected.count == 1);
  assert(rinzu_macos_window_destroy(second) == 0);
}

int main(void) {
  @autoreleasepool {
    void *session = rinzu_macos_session(rinzu_macos_open());
    assert(rinzu_macos_activation_policy(session, NSApplicationActivationPolicyRegular) == 0);
    assert(rinzu_macos_activation_policy(session, NSApplicationActivationPolicyRegular) == 0);
    void *window = rinzu_macos_window(
        rinzu_macos_window_create(session, (const uint8_t *)"First", 5, 460, 280));
    assert(window && rinzu_macos_window_show(window) == 0);
    assert(rinzu_macos_prepare_events(session) == 0);
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.01
                                                     repeats:NO
                                                       block:^(NSTimer *tick) {
                                                         (void)tick;
                                                         exercise(session, window);
                                                         exercise_transparency(session, window);
                                                         exercise_text_keys(session, window);
                                                         if (rinzu_macos_metal_available())
                                                           exercise_live_resize(session, window);
                                                         assert(rinzu_macos_stop(session) == 0);
                                                       }];
    assert(rinzu_macos_run_events(session) == 0);
    [timer invalidate];
    assert(rinzu_macos_close(session) == 0);
    struct MacStatistics stats;
    assert(rinzu_macos_statistics(&stats) == 0);
    assert(stats.windows + stats.views + stats.retainedControls == 0);
    puts("PASS:windows:tabs:divider:placement:reopen:cleanup");
  }
}
