import '../models/ktp_result.dart'; // We will reuse or extend KtpField

abstract class FieldParser {
  KtpField parse(String rawValue, String sourceImage);
}

class AlphaParser implements FieldParser {
  @override
  KtpField parse(String rawValue, String sourceImage) {
    String cleaned = rawValue.replaceAll(RegExp(r'[^A-Z\s\.\,\-]'), '').trim();
    return KtpField(
      value: cleaned,
      confidence: cleaned.isNotEmpty ? 90.0 : 0.0,
      source: sourceImage,
      corrected: rawValue != cleaned,
    );
  }
}
