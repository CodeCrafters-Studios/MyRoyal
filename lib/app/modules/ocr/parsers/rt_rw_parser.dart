import '../models/ktp_result.dart';
import '../models/ocr_candidate.dart';

class RtRwParser {
  Map<String, KtpField> parse(String rawValue, String sourceImage) {
    final res = parseRtRw(rawValue, sourceImage);
    return {
      'RT': KtpField(
        value: res['RT']!.value,
        confidence: res['RT']!.score,
        corrected: res['RT']!.corrected,
        source: sourceImage,
      ),
      'RW': KtpField(
        value: res['RW']!.value,
        confidence: res['RW']!.score,
        corrected: res['RW']!.corrected,
        source: sourceImage,
      ),
    };
  }

  static Map<String, OcrCandidate> parseRtRw(String rawText, String sourceName,
      {double? mlKitConfidence}) {
    String cleanInput = rawText
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1')
        .replaceAll('L', '1')
        .replaceAll('B', '8')
        .replaceAll('S', '5')
        .replaceAll('Z', '2');

    List<String> parts = cleanInput.split(RegExp(r'[\/\-]'));

    String rtRaw = '';
    String rwRaw = '';

    if (parts.length >= 2) {
      rtRaw = _cleanDigits(parts[0]);
      rwRaw = _cleanDigits(parts[1]);
    } else {
      String cleanDigits = _cleanDigits(cleanInput);
      if (cleanDigits.length == 6) {
        rtRaw = cleanDigits.substring(0, 3);
        rwRaw = cleanDigits.substring(3, 6);
      } else if (cleanDigits.isNotEmpty) {
        rtRaw = cleanDigits;
      }
    }

    final rtCandidate =
        _createRtRwCandidate(rtRaw, 'RT', sourceName, mlKitConfidence);
    final rwCandidate =
        _createRtRwCandidate(rwRaw, 'RW', sourceName, mlKitConfidence);

    return {
      'RT': rtCandidate,
      'RW': rwCandidate,
    };
  }

  static OcrCandidate _createRtRwCandidate(String rawDigits, String label,
      String sourceName, double? mlKitConfidence) {
    if (rawDigits.isEmpty) {
      return OcrCandidate(
          value: '', score: 0.0, source: sourceName, structurallyValid: false);
    }

    // Pad with leading zeros if 1 or 2 digits (e.g. "1" -> "001", "12" -> "012")
    String padded = rawDigits.padLeft(3, '0');
    if (padded.length > 3) {
      padded = padded.substring(0, 3);
    }

    final bool isExact3Digits =
        padded.length == 3 && RegExp(r'^\d{3}$').hasMatch(padded);
    final double score = isExact3Digits
        ? (mlKitConfidence != null && mlKitConfidence > 0
            ? mlKitConfidence.clamp(0.0, 90.0)
            : (rawDigits != padded ? 78.0 : 85.0))
        : 40.0;

    return OcrCandidate(
      value: padded,
      score: score,
      source: sourceName,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: isExact3Digits,
      corrected: rawDigits != padded,
    );
  }

  static String _cleanDigits(String input) {
    return input.replaceAll(RegExp(r'[^0-9]'), '');
  }
}
