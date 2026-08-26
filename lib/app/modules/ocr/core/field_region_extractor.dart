import 'dart:ui';
import 'ktp_template.dart';
import 'layout_analyzer.dart';
import 'label_detector.dart';

class FieldRegionExtractor {
  final LayoutAnalyzer analyzer;
  final LabelDetector labelDetector;

  FieldRegionExtractor(this.analyzer, this.labelDetector);

  /// Extracts the raw text value for each label based on its physical location rules
  Map<String, String> extractFieldValues() {
    Map<String, Rect> anchors = labelDetector.detectLabels();
    Map<String, String> extractedValues = {};

    for (var entry in anchors.entries) {
      String labelKey = entry.key;
      Rect anchorRect = entry.value;
      KtpLabel template = KtpTemplate.labels[labelKey]!;

      String? value;

      if (template.valuePosition == ValuePosition.right) {
        value = analyzer.findTextToRight(anchorRect);
      } else if (template.valuePosition == ValuePosition.below) {
        value = analyzer.findTextBelow(anchorRect);
      } else if (template.valuePosition == ValuePosition.rightOrBelow) {
        // Try right first, if null or empty, try below
        value = analyzer.findTextToRight(anchorRect);
        if (value == null || value.isEmpty) {
          value = analyzer.findTextBelow(anchorRect);
        }
      }

      // Inline merge extraction: Sometimes OCR merges "NAMAALGHANY" into one block
      // If the label bounds contained both, we need to extract the part after the label text
      if (value == null || value.isEmpty) {
        String anchorText = analyzer
            .getSortedLines()
            .firstWhere((l) => l.boundingBox == anchorRect)
            .text;

        for (String alias in template.aliases) {
          if (anchorText.toUpperCase().startsWith(alias) &&
              anchorText.length > alias.length) {
            String remainder = anchorText.substring(alias.length).trim();
            if (remainder.startsWith(':')) {
              remainder = remainder.substring(1).trim();
            }
            if (remainder.isNotEmpty) {
              value = remainder;
              break;
            }
          }
        }
      }

      if (value != null && value.isNotEmpty) {
        // Prevent extracting other labels as values
        if (!_isKnownLabel(value)) {
          extractedValues[labelKey] = value;
        }
      }
    }

    // Global Regex Fallbacks
    // If NIK is missing, search the entire document for 16-digit number
    if (!extractedValues.containsKey('NIK') ||
        extractedValues['NIK']!.isEmpty) {
      String? fallbackNik = _findRegexInDocument(RegExp(r'\b\d{16}\b'));
      if (fallbackNik != null) {
        extractedValues['NIK'] = fallbackNik;
      } else {
        // Try a looser regex if there are typos (e.g. O instead of 0)
        String? looseNik = _findRegexInDocument(
            RegExp(r'\b[0-9OIl!BSEZG\?]{16}\b', caseSensitive: false));
        if (looseNik != null) {
          extractedValues['NIK'] = looseNik;
        }
      }
    }

    return extractedValues;
  }

  String? _findRegexInDocument(RegExp regex) {
    for (var line in analyzer.getSortedLines()) {
      // Remove spaces in case NIK is spaced out
      String textNoSpaces = line.text.replaceAll(' ', '');
      if (regex.hasMatch(textNoSpaces)) {
        return regex.stringMatch(textNoSpaces);
      }
      if (regex.hasMatch(line.text)) {
        return regex.stringMatch(line.text);
      }
    }
    return null;
  }

  bool _isKnownLabel(String text) {
    String upper = text.toUpperCase().replaceAll(RegExp(r'[^A-Z]'), '');
    if (upper.length < 3) return false;

    for (var label in KtpTemplate.labels.values) {
      for (var alias in label.aliases) {
        String cleanAlias = alias.replaceAll(RegExp(r'[^A-Z]'), '');
        if (cleanAlias.isNotEmpty && upper.contains(cleanAlias)) {
          // If the extracted text is exactly a label or contains a major label completely, reject it.
          // Exception: "NAMA" could be in someone's name, but typically labels stand alone.
          // Let's only reject if it's a very close match to the label
          if (upper.length <= cleanAlias.length + 3) {
            return true;
          }
        }
      }
    }
    return false;
  }
}
