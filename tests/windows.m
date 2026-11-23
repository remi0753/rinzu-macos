#include "../native/src/macos.m"
#include <assert.h>
#include <stdio.h>

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
