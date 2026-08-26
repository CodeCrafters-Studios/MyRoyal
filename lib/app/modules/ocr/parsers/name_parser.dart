import '../models/ocr_candidate.dart';

class NameParser {
  /// Parses raw OCR text from Name ROI into a cleaned Name candidate.
  /// Preserves multi-word names, single-letter initials (e.g. "ALGHANY K"),
  /// removes OCR symbol noise without aggressively fuzzy matching against dictionary names.
  static OcrCandidate parse(String rawText, String sourceName,
      {double? mlKitConfidence}) {
    if (rawText.trim().isEmpty) {
      return OcrCandidate(
        value: '',
        score: 0.0,
        source: sourceName,
        structurallyValid: false,
      );
    }

    // Clean prefix colons, leading labels "NAMA" if present in crop edge
    String cleaned = rawText.trim();
    if (cleaned.toUpperCase().startsWith('NAMA')) {
      cleaned = cleaned.substring(4).replaceAll(RegExp(r'^[\s:]+'), '').trim();
    }
    if (cleaned.startsWith(':')) {
      cleaned = cleaned.substring(1).trim();
    }

    // Retain uppercase alphabetic characters, single quotes, dots (for initials), and spaces
    cleaned = cleaned
        .replaceAll(RegExp(r"[^a-zA-Z\s\.']"), '')
        .toUpperCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    final bool isValidName =
        cleaned.length >= 2 && RegExp(r"^[A-Z\s\.']+$").hasMatch(cleaned);

    double score = 0.0;
    if (isValidName) {
      if (mlKitConfidence != null && mlKitConfidence > 0) {
        score = mlKitConfidence.clamp(0.0, 90.0);
      } else {
        score = 76.5;
        if (cleaned.contains(' ')) score += 5.5;
        if (cleaned.length >= 3 && cleaned.length <= 40) score += 4.5;
      }
    }

    return OcrCandidate(
      value: cleaned,
      score: score.clamp(0.0, 90.0),
      source: sourceName,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: isValidName,
      corrected: rawText.trim() != cleaned,
    );
  }
}
