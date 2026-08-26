import '../models/ktp_result.dart';
import 'date_parser.dart';

class TtlParser {
  /// Legacy wrapper returning Map with 'Tempat Lahir' and 'Tgl Lahir' KtpField objects.
  Map<String, KtpField> parse(String rawValue, String sourceImage) {
    final parsedMap = DateParser.parseBirthPlaceAndDate(rawValue, sourceImage);
    final placeCandidate = parsedMap['birthPlace']!;
    final dateCandidate = parsedMap['birthDate']!;

    return {
      'Tempat Lahir': KtpField(
        value: placeCandidate.value,
        confidence: placeCandidate.score,
        source: sourceImage,
        corrected: placeCandidate.corrected,
      ),
      'Tgl Lahir': KtpField(
        value: dateCandidate.value,
        confidence: dateCandidate.score,
        source: sourceImage,
        corrected: dateCandidate.corrected,
      ),
    };
  }
}
