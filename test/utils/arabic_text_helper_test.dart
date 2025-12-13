import 'package:flutter_test/flutter_test.dart';
import 'package:wasslni_plus/utils/arabic_text_helper.dart';

void main() {
  group('ArabicTextHelper', () {
    test('shapeArabicText processes known letters', () {
      // Test the letter 'Beh' (ب)
      // Isolated: \uFE8F
      expect(ArabicTextHelper.shapeArabicText('\u0628'), '\uFE8F');
    });

    test('reverses text for RTL rendering', () {
      // Input: "123"
      // Expected: "321" (Simple reverse)
      expect(ArabicTextHelper.shapeArabicText('123'), '321');
    });

    test('handles mixed content gracefully', () {
      // If we mix Arabic and Latin, it should reverse all?
      // "A" + "ب" -> "\uFE8F" + "A". Reversed: "A\uFE8F" -> "\uFE8FA" ?
      // No, input "A\u0628".
      // Process:
      // chars[0] = 'A'. Not in map -> 'A'.
      // chars[1] = '\u0628'. In map -> Isolated '\uFE8F'.
      // List: ['A', '\uFE8F'].
      // Reversed: '\uFE8F', 'A'. Joined: '\uFE8FA'.

      expect(ArabicTextHelper.shapeArabicText('A\u0628'), '\uFE8FA');
    });
  });
}
