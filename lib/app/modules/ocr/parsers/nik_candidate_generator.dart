import '../models/ocr_candidate.dart';

class NikCandidateGenerator {
  static const Map<String, String> _substitutions = {
    'O': '0',
    'o': '0',
    'I': '1',
    'l': '1',
    'L': '1',
    'i': '1',
    'B': '8',
    'S': '5',
    'Z': '2',
    'G': '6',
    'E': '3',
    'D': '0',
    'b': '6',
    '?': '7',
  };

  /// Generates a list of candidate NIK digit strings from raw OCR line or element text.
  static List<OcrCandidate> generateCandidates({
    required List<String> rawTexts,
    required String sourceName,
    double? mlKitConfidence,
  }) {
    List<OcrCandidate> candidates = [];
    Set<String> seenValues = {};

    for (final raw in rawTexts) {
      if (raw.trim().isEmpty) continue;

      String text = raw.trim();
      if (text.toUpperCase().startsWith('NIK')) {
        text = text.substring(3).replaceAll(RegExp(r'^[\s:]+'), '').trim();
      }

      // Clean input keeping digits and candidate letter keys
      final cleanInput = text.replaceAll(RegExp(r'\s+'), '').trim();

      // 1. Raw Digits Only candidate
      final digitsOnly = cleanInput.replaceAll(RegExp(r'[^0-9]'), '');
      _addCandidate(
        candidates,
        seenValues,
        value: digitsOnly,
        source: sourceName,
        mlKitConfidence: mlKitConfidence,
        corrected: false,
      );

      // 2. Applied Substitution candidate
      String substituted = cleanInput;
      bool wasCorrected = false;
      _substitutions.forEach((char, replacement) {
        if (substituted.contains(char)) {
          substituted = substituted.replaceAll(char, replacement);
          wasCorrected = true;
        }
      });
      final substitutedDigits = substituted.replaceAll(RegExp(r'[^0-9]'), '');

      _addCandidate(
        candidates,
        seenValues,
        value: substitutedDigits,
        source: '$sourceName-substituted',
        mlKitConfidence: mlKitConfidence,
        corrected: wasCorrected,
      );
    }

    return candidates;
  }

  static void _addCandidate(
    List<OcrCandidate> candidates,
    Set<String> seenValues, {
    required String value,
    required String source,
    double? mlKitConfidence,
    required bool corrected,
  }) {
    if (value.isEmpty || seenValues.contains(value)) return;
    seenValues.add(value);

    final bool isExact16Digits =
        value.length == 16 && RegExp(r'^\d{16}$').hasMatch(value);

    // Score calculation based on ML Kit text recognition confidence
    double score = 0.0;
    if (isExact16Digits) {
      score = mlKitConfidence != null && mlKitConfidence > 0
          ? mlKitConfidence.clamp(0.0, 90.0)
          : (corrected ? 78.5 : 86.2);
    } else {
      // Reject incomplete 10-15 digit NIKs from receiving high structural confidence
      score = value.length >= 10 && value.length <= 15 ? 20.0 : 5.0;
    }

    candidates.add(OcrCandidate(
      value: value,
      score: score.clamp(0.0, 90.0),
      source: source,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: isExact16Digits,
      corrected: corrected,
    ));
  }
}
