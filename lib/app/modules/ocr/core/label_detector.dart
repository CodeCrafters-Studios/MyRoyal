import 'dart:ui';
import 'ktp_template.dart';
import 'layout_analyzer.dart';
import 'ocr_document.dart';

class LabelDetector {
  final LayoutAnalyzer analyzer;

  LabelDetector(this.analyzer);

  /// Finds the physical Rect bounds of each label defined in the KtpTemplate
  Map<String, Rect> detectLabels() {
    Map<String, Rect> foundLabels = {};
    List<OcrLine> allLines = analyzer.getSortedLines();

    for (var line in allLines) {
      String upperText = line.text.toUpperCase().trim();

      for (var templateLabel in KtpTemplate.labels.values) {
        if (foundLabels.containsKey(templateLabel.key)) continue;

        for (var alias in templateLabel.aliases) {
          if (upperText.contains(alias)) {
            // Found a label block. We store its BoundingBox
            foundLabels[templateLabel.key] = line.boundingBox;
            break; // Stop checking aliases for this label
          }
        }
      }
    }

    return foundLabels;
  }
}
