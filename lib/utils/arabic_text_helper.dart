// Arabic text helper for PDF generation
// This helps with Arabic ligature rendering

class ArabicTextHelper {
  // Arabic Unicode ranges and contextual forms
  static const Map<String, Map<String, String>> _arabicLetterForms = {
    // Letter Beh: ب
    '\u0628': {
      'isolated': '\uFE8F',
      'initial': '\uFE91',
      'medial': '\uFE92',
      'final': '\uFE90',
    },
    // Letter Lam: ل
    '\u0644': {
      'isolated': '\uFEDD',
      'initial': '\uFEDF',
      'medial': '\uFEE0',
      'final': '\uFEDE',
    },
    // Letter Seen: س
    '\u0633': {
      'isolated': '\uFEB1',
      'initial': '\uFEB3',
      'medial': '\uFEB4',
      'final': '\uFEB2',
    },
    // Letter Noon: ن
    '\u0646': {
      'isolated': '\uFEE5',
      'initial': '\uFEE7',
      'medial': '\uFEE8',
      'final': '\uFEE6',
    },
    // Letter Yeh: ي
    '\u064A': {
      'isolated': '\uFEF1',
      'initial': '\uFEF3',
      'medial': '\uFEF4',
      'final': '\uFEF2',
    },
    // Letter Waw: و
    '\u0648': {
      'isolated': '\uFEED',
      'final': '\uFEEE', // Waw only has isolated and final forms
    },
    // Letter Sad: ص
    '\u0635': {
      'isolated': '\uFEB9',
      'initial': '\uFEBB',
      'medial': '\uFEBC',
      'final': '\uFEBA',
    },
    // Letter Meem: م
    '\u0645': {
      'isolated': '\uFEE1',
      'initial': '\uFEE3',
      'medial': '\uFEE4',
      'final': '\uFEE2',
    },
    // Add more letters as needed...
  };

  // Non-connecting letters (ا د ذ ر ز و)
  static const Set<String> _nonConnecting = {
    '\u0627', // Alef
    '\u062F', // Dal
    '\u0630', // Thal
    '\u0631', // Reh
    '\u0632', // Zain
    '\u0648', // Waw
  };

  /// Shape Arabic text for proper ligature display in PDF
  /// This is a simplified implementation - for production use, consider a dedicated package
  static String shapeArabicText(String text) {
    if (text.isEmpty) return text;

    final List<String> chars = text.split('');
    final List<String> shaped = [];

    for (int i = 0; i < chars.length; i++) {
      final current = chars[i];
      final next = i < chars.length - 1 ? chars[i + 1] : null;
      final prev = i > 0 ? chars[i - 1] : null;

      // Check if current character is Arabic
      if (!_arabicLetterForms.containsKey(current)) {
        shaped.add(current);
        continue;
      }

      final forms = _arabicLetterForms[current]!;
      final bool prevConnects = prev != null &&
          !_nonConnecting.contains(prev) &&
          _arabicLetterForms.containsKey(prev);
      final bool nextConnects = next != null &&
          !_nonConnecting.contains(current) &&
          _arabicLetterForms.containsKey(next);

      String shapedChar;
      if (prevConnects && nextConnects) {
        shapedChar = forms['medial'] ?? forms['isolated']!;
      } else if (prevConnects) {
        shapedChar = forms['final'] ?? forms['isolated']!;
      } else if (nextConnects) {
        shapedChar = forms['initial'] ?? forms['isolated']!;
      } else {
        shapedChar = forms['isolated']!;
      }

      shaped.add(shapedChar);
    }

    // Reverse for RTL display
    return shaped.reversed.join('');
  }
}
