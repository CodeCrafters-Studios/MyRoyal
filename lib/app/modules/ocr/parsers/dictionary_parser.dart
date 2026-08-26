import '../models/ktp_result.dart';
import '../models/ocr_candidate.dart';
import 'field_parser.dart';

class DictionaryParser implements FieldParser {
  final List<String> dictionary;
  final int maxDistance;
  final double minConfidenceThreshold;

  DictionaryParser({
    required this.dictionary,
    this.maxDistance = 2,
    this.minConfidenceThreshold = 65.0,
  });

  @override
  KtpField parse(String rawValue, String sourceImage) {
    final candidate = parseCandidate(rawValue, sourceImage);
    return KtpField(
      value: candidate.value,
      confidence: candidate.score,
      corrected: candidate.corrected,
      source: candidate.source,
    );
  }

  OcrCandidate parseCandidate(String rawValue, String sourceName,
      {double? mlKitConfidence}) {
    String cleanInput = rawValue
        .replaceAll(RegExp(r'[^A-Z0-9\s\/\-]'), '')
        .toUpperCase()
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();

    if (cleanInput.isEmpty) {
      return OcrCandidate(
        value: '',
        score: 0.0,
        source: sourceName,
        structurallyValid: false,
      );
    }

    // 1. Exact Match Check
    for (final dictValue in dictionary) {
      if (cleanInput == dictValue.toUpperCase()) {
        return OcrCandidate(
          value: dictValue,
          score: 90.0, // Local mobile score capped at 90.0
          source: sourceName,
          mlKitConfidence: mlKitConfidence,
          structurallyValid: true,
          corrected: false,
        );
      }
    }

    // 2. Relative Edit Distance Search
    double bestScore = -1.0;
    String? bestMatch;
    int minDistance = 999;

    for (final dictValue in dictionary) {
      final String dictUpper = dictValue.toUpperCase();
      final int dist = _levenshtein(cleanInput, dictUpper);

      final double relativeEditDist = dist / dictUpper.length.toDouble();

      // Calculate evidence score
      double score = (1.0 - relativeEditDist) * 90.0;
      if (dist == 0) score = 90.0;

      if (dist < minDistance && score > bestScore) {
        minDistance = dist;
        bestScore = score;
        bestMatch = dictValue;
      }
    }

    // Check threshold gate
    if (bestMatch != null && bestScore >= minConfidenceThreshold) {
      return OcrCandidate(
        value: bestMatch,
        score: bestScore.clamp(0.0, 90.0),
        source: sourceName,
        mlKitConfidence: mlKitConfidence,
        structurallyValid: true,
        corrected: minDistance > 0,
      );
    }

    // Fallback: If below threshold, return raw clean value with low score
    return OcrCandidate(
      value: cleanInput,
      score: 30.0,
      source: sourceName,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: false,
      corrected: false,
    );
  }

  static int _levenshtein(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    List<int> v0 = List<int>.generate(b.length + 1, (i) => i);
    List<int> v1 = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      v1[0] = i + 1;
      for (int j = 0; j < b.length; j++) {
        int cost = (a[i] == b[j]) ? 0 : 1;
        v1[j + 1] = [v1[j] + 1, v0[j + 1] + 1, v0[j] + cost]
            .reduce((min, val) => min < val ? min : val);
      }
      for (int j = 0; j <= b.length; j++) {
        v0[j] = v1[j];
      }
    }
    return v1[b.length];
  }
}
