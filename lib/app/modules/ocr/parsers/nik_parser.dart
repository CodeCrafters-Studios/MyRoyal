import 'field_parser.dart';
import '../models/ktp_result.dart';
import 'nik_candidate_generator.dart';

class NikParser implements FieldParser {
  @override
  KtpField parse(String rawValue, String sourceImage) {
    final candidates = NikCandidateGenerator.generateCandidates(
      rawTexts: [rawValue],
      sourceName: sourceImage,
    );

    if (candidates.isEmpty) {
      return KtpField(value: '', confidence: 0.0, source: sourceImage);
    }

    // Sort by score descending
    candidates.sort((a, b) => b.score.compareTo(a.score));
    final best = candidates.first;

    return KtpField(
      value: best.value,
      confidence: best.score,
      corrected: best.corrected,
      source: best.source,
    );
  }
}
