#import <AppKit/AppKit.h>
#include <stdint.h>

static NSWindow *fixture_window(NSString *title) {
  if (![NSThread isMainThread])
    return nil;
  for (NSWindow *window in NSApp.windows)
    if ([window.title isEqualToString:title])
      return window;
  return nil;
}

int32_t rinzu_editor_test_mark_text(void) {
  NSResponder *responder = fixture_window(@"Editor IME close").firstResponder;
  if (![responder conformsToProtocol:@protocol(NSTextInputClient)])
    return 0;

  id<NSTextInputClient> input = (id<NSTextInputClient>)responder;
  [input setMarkedText:@"かな"
         selectedRange:NSMakeRange(2, 0)
      replacementRange:NSMakeRange(NSNotFound, 0)];
  return input.hasMarkedText;
}

static NSTextView *binding_input(void) {
  NSResponder *responder = fixture_window(@"Document binding events").firstResponder;
  return [responder isKindOfClass:[NSTextView class]] ? (NSTextView *)responder : nil;
}

int32_t rinzu_binding_test_insert(void) {
  NSTextView *input = binding_input();
  if (!input)
    return 0;
  [input insertText:@"入力 日本🙂" replacementRange:NSMakeRange(0, input.string.length)];
  [input setSelectedRange:NSMakeRange(3, 2)];
  return 1;
}

int32_t rinzu_binding_test_select(void) {
  NSTextView *input = binding_input();
  if (!input)
    return 0;
  [input setSelectedRange:NSMakeRange(0, 1)];
  return 1;
}

int32_t rinzu_binding_test_mark(void) {
  NSTextView *input = binding_input();
  if (!input)
    return 0;
  [input setMarkedText:@"仮" selectedRange:NSMakeRange(1, 0) replacementRange:NSMakeRange(0, 0)];
  if (input.hasMarkedText)
    [input setSelectedRange:NSMakeRange(input.markedRange.location, 0)];
  return input.hasMarkedText;
}

int32_t rinzu_binding_test_commit(void) {
  NSTextView *input = binding_input();
  if (!input.hasMarkedText)
    return 0;
  [input unmarkText];
  return !input.hasMarkedText;
}

static NSButton *button_with_title(NSView *view, NSString *title) {
  if ([view isKindOfClass:[NSButton class]] && [((NSButton *)view).title isEqualToString:title])
    return (NSButton *)view;
  for (NSView *child in view.subviews) {
    NSButton *button = button_with_title(child, title);
    if (button)
      return button;
  }
  return nil;
}

int32_t rinzu_sheet_test_click_alert(int32_t choice) {
  NSWindow *sheet = fixture_window(@"Sheet results").attachedSheet;
  if (!sheet.visible)
    return 0;
  NSArray<NSString *> *titles = @[ @"Cancel", @"Discard", @"Save" ];
  if (choice < 1 || (NSUInteger)choice > titles.count)
    return -1;
  NSButton *button = button_with_title(sheet.contentView, titles[(NSUInteger)choice - 1]);
  if (!button.enabled)
    return -1;
  [button performClick:nil];
  return 1;
}

int32_t rinzu_sheet_test_accept_panel(void) {
  NSWindow *parent = fixture_window(@"Sheet results");
  NSWindow *sheet = parent.attachedSheet;
  if (!sheet.visible)
    return 0;
  if (![sheet isKindOfClass:[NSSavePanel class]])
    return -1;
  [parent endSheet:sheet returnCode:NSModalResponseOK];
  return 1;
}
