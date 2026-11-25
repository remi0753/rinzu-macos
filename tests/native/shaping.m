#include "../../native/src/macos.m"
#include <assert.h>
#include <pthread.h>
#include <stdio.h>

static NSDictionary *snapshot(const rinzu_native_byte_array_t *data) {
  assert(data && data->length && data->length <= 16777216);
  NSDictionary *value = [NSJSONSerialization JSONObjectWithData:[NSData dataWithBytes:data->data
                                                                               length:data->length]
                                                        options:0
                                                          error:NULL];
  assert(value && [value[@"version"] intValue] == 1);
  return value;
}
static void *foreign(void *raw) {
  @autoreleasepool {
    assert(rinzu_macos_font_catalog(raw) == RZ_OWNER);
  }
  return NULL;
}
static void metadata(void *session) {
  assert(rinzu_macos_font_catalog(session) == 0);
  NSDictionary *catalog = snapshot(rinzu_macos_font_catalog_bytes(session));
  assert([catalog[@"faces"] count] > 10);
  BOOL menlo = NO;
  for (NSDictionary *face in catalog[@"faces"])
    if ([face[@"postscriptName"] isEqual:@"Menlo-Regular"])
      menlo = YES;
  assert(menlo);
  void *font = rinzu_macos_font(
      rinzu_macos_font_create(session, (const uint8_t *)"Menlo-Regular", 13, 13, 0));
  assert(font);
  for (int i = 0; i < 4; i++) {
    int64_t token = rinzu_macos_font_traits(font, i);
    assert(token > 0);
    void *derived = rinzu_macos_font(token);
    assert(rinzu_macos_font_info_snapshot(derived) == 0);
    NSDictionary *info = snapshot(rinzu_macos_font_info_bytes(derived));
    assert(([info[@"traits"] intValue] & 7) == (i | 4));
    assert(rinzu_macos_font_variation(derived, -1, 0) == RZ_ARGUMENT);
    assert(rinzu_macos_font_variation(derived, 0, NAN) == RZ_ARGUMENT);
    assert(rinzu_macos_font_variation(derived, 0, 1) == RZ_ARGUMENT);
    assert(rinzu_macos_font_destroy(derived) == 0);
    assert(rinzu_macos_font_info_snapshot(derived) == RZ_INVALID);
  }
  // Test the generic axis API against any available variable face, without a fixed system-font
  // name.
  unsigned axisCount = 0;
  for (NSDictionary *face in catalog[@"faces"]) {
    NSString *name = face[@"postscriptName"];
    CTFontRef candidate = CTFontCreateWithName((__bridge CFStringRef)name, 13, NULL);
    NSArray *axes = CFBridgingRelease(CTFontCopyVariationAxes(candidate));
    CFRelease(candidate);
    if (!axes.count)
      continue;
    NSData *nameBytes = [name dataUsingEncoding:NSUTF8StringEncoding];
    void *variable = rinzu_macos_font(
        rinzu_macos_font_create(session, nameBytes.bytes, nameBytes.length, 13, 0));
    assert(variable);
    NSDictionary *axis = axes[0];
    int64_t identifier =
        (uint32_t)[axis[(__bridge id)kCTFontVariationAxisIdentifierKey] longLongValue];
    double minimum = [axis[(__bridge id)kCTFontVariationAxisMinimumValueKey] doubleValue];
    double maximum = [axis[(__bridge id)kCTFontVariationAxisMaximumValueKey] doubleValue];
    double selected = minimum + (maximum - minimum) * .75;
    int64_t token = rinzu_macos_font_variation(variable, identifier, selected);
    assert(token > 0);
    void *derived = rinzu_macos_font(token);
    assert(rinzu_macos_font_info_snapshot(derived) == 0);
    NSDictionary *info = snapshot(rinzu_macos_font_info_bytes(derived));
    BOOL matched = NO;
    for (NSDictionary *value in info[@"axes"])
      if ([value[@"identifier"] longLongValue] == identifier) {
        assert(fabs([value[@"value"] doubleValue] - selected) < 1e-5);
        matched = YES;
      }
    assert(matched);
    assert(rinzu_macos_font_variation(variable, identifier, maximum + 1) == RZ_ARGUMENT);
    assert(rinzu_macos_font_destroy(derived) == 0);
    assert(rinzu_macos_font_destroy(variable) == 0);
    axisCount++;
    break;
  }
  assert(axisCount);
  assert(rinzu_macos_font_traits(font, 4) == RZ_ARGUMENT);
  assert(rinzu_macos_font_destroy(font) == 0);
  pthread_t worker;
  assert(pthread_create(&worker, NULL, foreign, session) == 0);
  assert(pthread_join(worker, NULL) == 0);
  puts("PASS:shaping:catalog:four-styles:variation:ownership:bounds");
}
static unsigned rasterOracle(void *device, void *fragment, CTLineRef oracle, double anchor,
                             int scale, unsigned tolerance) {
  struct MacTextMetrics m;
  assert(rinzu_macos_text_metrics(fragment, &m) == 0);
  size_t width = (size_t)ceil(m.rasterWidth * scale), height = (size_t)ceil(m.rasterHeight * scale),
         length = width * height * 4;
  NSMutableData *expected = [NSMutableData dataWithLength:length];
  CGColorSpaceRef space = CGColorSpaceCreateWithName(kCGColorSpaceSRGB);
  CGContextRef context =
      CGBitmapContextCreate(expected.mutableBytes, width, height, 8, width * 4, space,
                            kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
  CGColorSpaceRelease(space);
  assert(context);
  CGContextSetShouldAntialias(context, true);
  CGContextSetShouldSmoothFonts(context, false);
  CGContextTranslateCTM(context, -m.left * scale, height + m.top * scale);
  CGContextScaleCTM(context, scale, scale);
  CGContextTranslateCTM(context, -anchor, 0);
  CGContextSetTextMatrix(context, CGAffineTransformIdentity);
  CTLineDraw(oracle, context);
  CGContextRelease(context);
  int64_t token = rinzu_macos_text_texture(device, fragment, scale);
  assert(token > 0);
  void *texture = rinzu_macos_texture(token);
  struct MacScissor all = {0, 0, width, height};
  assert(rinzu_macos_texture_read(texture, &all) == 0);
  const rinzu_native_byte_array_t *actual = rinzu_macos_texture_bytes(texture);
  assert(actual->length == length);
  unsigned worst = 0;
  for (size_t i = 0; i < length; i++) {
    unsigned difference =
        (unsigned)abs((int)actual->data[i] - ((const uint8_t *)expected.bytes)[i]);
    if (difference > worst)
      worst = difference;
  }
  if (worst > tolerance)
    fprintf(stderr, "oracle mismatch scale=%d maxDelta=%u tolerance=%u\n", scale, worst, tolerance);
  assert(worst <= tolerance);
  assert(rinzu_macos_texture_destroy(texture) == 0);
  return worst;
}
static void partial(void *session, void *device) {
  unsigned worst = 0;
  const uint8_t *name = (const uint8_t *)"Menlo-Regular";
  void *font = rinzu_macos_font(rinzu_macos_font_create(session, name, 13, 18, 0));
  assert(font);
  assert(rinzu_macos_text_shape(font, (const uint8_t *)"\xff", 1, 1) == RZ_ARGUMENT);
  assert(rinzu_macos_text_shape(font, NULL, 65537, 1) == RZ_ARGUMENT);
  int64_t emptyId = rinzu_macos_text_shape(font, NULL, 0, 0);
  assert(emptyId > 0);
  void *empty = rinzu_macos_text(emptyId);
  assert(rinzu_macos_text_shape_snapshot(empty) == 0);
  assert([snapshot(rinzu_macos_text_shape_bytes(empty))[@"runs"] count] == 0);
  assert(rinzu_macos_text_fragment(empty, 0, 0) == RZ_ARGUMENT);
  assert(rinzu_macos_text_destroy(empty) == 0);
  for (NSString *middle in @[ @"B", @"日本語", @"👩🏽‍💻", @"é", @" " ]) {
    NSString *source = [NSString stringWithFormat:@"A%@Z", middle];
    NSData *input = [source dataUsingEncoding:NSUTF8StringEncoding];
    int64_t lineId = rinzu_macos_text_shape(font, input.bytes, input.length, 1);
    assert(lineId > 0);
    void *line = rinzu_macos_text(lineId);
    int64_t fragmentId = rinzu_macos_text_fragment(line, 1, 1 + middle.length);
    assert(fragmentId > 0);
    void *fragment = rinzu_macos_text(fragmentId);
    assert(rinzu_macos_text_destroy(line) == 0);
    CTFontRef oracleFont = CTFontCreateWithName(CFSTR("Menlo-Regular"), 18, NULL);
    NSAttributedString *attributed = [[NSAttributedString alloc]
        initWithString:middle
            attributes:@{
              (__bridge id)kCTFontAttributeName : (__bridge id)oracleFont,
              (__bridge id)kCTLigatureAttributeName : @1,
              (__bridge id)kCTForegroundColorAttributeName : (__bridge id)NSColor.whiteColor.CGColor
            }];
    CTLineRef oracle = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
    CFRelease(oracleFont);
    if (device) {
      unsigned one = rasterOracle(device, fragment, oracle, 0, 1, 0);
      unsigned two = rasterOracle(device, fragment, oracle, 0, 2, 0);
      worst = MAX(worst, MAX(one, two));
    }
    CFRelease(oracle);
    assert(rinzu_macos_text_destroy(fragment) == 0);
  }
  assert(rinzu_macos_font_destroy(font) == 0);
  printf("PASS:shaping:partial:source-retired:independent-oracle:invalid:empty:maxDelta=%u\n",
         worst);
}
static void corpus(void *session, void *device) {
  NSArray *values =
      @[ @"office ffi", @"日本語", @"👩🏽‍💻", @"🇯🇵", @"é", @"سلام", @"שָׁלוֹם" ];
  for (unsigned c = 0; c < values.count; c++)
    for (int lig = 0; lig < 2; lig++) {
      NSString *value = values[c];
      NSString *name = c ? @"Menlo-Regular" : @"Times-Roman";
      NSData *fontName = [name dataUsingEncoding:NSUTF8StringEncoding],
             *input = [value dataUsingEncoding:NSUTF8StringEncoding];
      void *font = rinzu_macos_font(
          rinzu_macos_font_create(session, fontName.bytes, fontName.length, 18, 0));
      assert(font);
      int64_t token = rinzu_macos_text_shape(font, input.bytes, input.length, lig);
      assert(token > 0);
      void *layout = rinzu_macos_text(token);
      assert(rinzu_macos_text_shape_snapshot(layout) == 0);
      NSDictionary *shape = snapshot(rinzu_macos_text_shape_bytes(layout));
      assert([shape[@"utf16Length"] unsignedIntegerValue] == value.length);
      CTFontRef oracleFont = CTFontCreateWithName((__bridge CFStringRef)name, 18, NULL);
      NSAttributedString *attributed = [[NSAttributedString alloc]
          initWithString:value
              attributes:@{
                (__bridge id)kCTFontAttributeName : (__bridge id)oracleFont,
                (__bridge id)kCTLigatureAttributeName : @(lig),
                (__bridge id)
                kCTForegroundColorAttributeName : (__bridge id)NSColor.whiteColor.CGColor
              }];
      CTLineRef oracle =
          CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)attributed);
      CFRelease(oracleFont);
      NSArray *runs = (__bridge NSArray *)CTLineGetGlyphRuns(oracle), *actual = shape[@"runs"];
      assert(runs.count == actual.count);
      assert([shape[@"advance"] doubleValue] ==
             CTLineGetTypographicBounds(oracle, NULL, NULL, NULL));
      BOOL fallback = NO, rtl = NO, color = NO, multi = NO;
      unsigned total = 0;
      double anchor = 0;
      BOOL first = YES;
      for (unsigned r = 0; r < runs.count; r++) {
        CTRunRef run = (__bridge CTRunRef)runs[r];
        NSArray *glyphs = actual[r][@"glyphs"];
        assert(glyphs.count == (NSUInteger)CTRunGetGlyphCount(run));
        assert(CFGetTypeID((__bridge CFTypeRef)actual[r][@"rtl"]) == CFBooleanGetTypeID());
        assert(CFGetTypeID((__bridge CFTypeRef)actual[r][@"isFallback"]) == CFBooleanGetTypeID());
        fallback |= [actual[r][@"isFallback"] boolValue];
        rtl |= [actual[r][@"rtl"] boolValue];
        color |= ([actual[r][@"font"][@"traits"] intValue] & 8) != 0;
        for (unsigned g = 0; g < glyphs.count; g++) {
          CGGlyph glyph;
          CGPoint point;
          CGSize advance;
          CFIndex index;
          CTRunGetGlyphs(run, CFRangeMake(g, 1), &glyph);
          CTRunGetPositions(run, CFRangeMake(g, 1), &point);
          CTRunGetAdvances(run, CFRangeMake(g, 1), &advance);
          CTRunGetStringIndices(run, CFRangeMake(g, 1), &index);
          NSDictionary *a = glyphs[g];
          assert([a[@"identity"] unsignedIntValue] == glyph &&
                 [a[@"start"] longLongValue] == index);
          assert([a[@"x"] doubleValue] == point.x && [a[@"y"] doubleValue] == point.y &&
                 [a[@"advanceX"] doubleValue] == advance.width);
          int64_t start = [a[@"start"] longLongValue], end = [a[@"end"] longLongValue];
          assert(start >= 0 && end > start && end <= (int64_t)value.length);
          multi |= end - start > 1;
          if (first) {
            anchor = point.x;
            first = NO;
          }
          if (end - start > 1)
            assert(rinzu_macos_text_fragment(layout, start, start + 1) == RZ_ARGUMENT);
          total++;
        }
      }
      assert(total > 0 && rtl == (c >= 5));
      if (c == 1 || c == 2 || c == 3 || c >= 5)
        assert(fallback);
      if (c == 2 || c == 3)
        assert(color);
      if (c == 0 && lig)
        assert(multi && total < value.length);
      token = rinzu_macos_text_fragment(layout, 0, value.length);
      assert(token > 0);
      void *fragment = rinzu_macos_text(token);
      assert(rinzu_macos_font_destroy(font) == RZ_BUSY);
      assert(rinzu_macos_text_shape_snapshot(fragment) == RZ_ARGUMENT);
      assert(rinzu_macos_text_fragment(layout, -1, 1) == RZ_ARGUMENT);
      assert(rinzu_macos_text_fragment(layout, 0, INT64_MAX) == RZ_ARGUMENT);
      assert(rinzu_macos_text_destroy(layout) == 0);
      if (device) {
        rasterOracle(device, fragment, oracle, anchor, 1, 0);
        rasterOracle(device, fragment, oracle, anchor, 2, 0);
      }
      assert(rinzu_macos_text_destroy(fragment) == 0);
      assert(rinzu_macos_font_destroy(font) == 0);
      CFRelease(oracle);
    }
  puts("PASS:shaping:7-corpus:ligatures-on-off:runs:glyphs:utf16:fragments:oracle");
}
int main(int argc, const char **argv) {
  @autoreleasepool {
    assert(argc == 2);
    void *session = rinzu_macos_session(rinzu_macos_open());
    assert(session);
    metadata(session);
    void *device = NULL;
    if (!strcmp(argv[1], "raster")) {
      assert(rinzu_macos_metal_available());
      device = rinzu_macos_device(rinzu_macos_device_create(session));
      assert(device);
    }
    corpus(session, device);
    partial(session, device);
    assert(rinzu_macos_close(session) == 0);
    struct MacStatistics s;
    assert(rinzu_macos_statistics(&s) == 0 && !s.retainedControls && !s.textBytes &&
           !s.snapshotBytes && !s.textureBytes);
    puts("PASS:shaping:closed:resources=0");
    return 0;
  }
}
