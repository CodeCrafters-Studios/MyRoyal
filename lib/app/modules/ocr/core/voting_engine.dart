import '../models/ktp_result.dart';
import '../models/ocr_candidate.dart';
import 'candidate_scorer.dart';

class VotingEngine {
  /// Consolidates candidates generated from multiple field crop OCR passes into candidate pool.
  /// Group similar candidates, score groups based on cross-pass agreement consensus,
  /// structural validity, and evidence scoring, returning the best KtpField.
  static KtpField selectBestField({
    required List<OcrCandidate> candidatePool,
    required bool Function(String) validator,
    required String fieldName,
    double lowConfidenceThreshold = 70.0,
  }) {
    // Filter out empty candidates
    final validPool =
        candidatePool.where((c) => c.value.trim().isNotEmpty).toList();
    if (validPool.isEmpty) {
      return KtpField(
          value: '', confidence: 0.0, source: 'none', corrected: false);
    }

    // Group candidates by normalized value string
    final Map<String, List<OcrCandidate>> groups = {};
    for (final candidate in validPool) {
      final key = candidate.value.trim().toUpperCase();
      groups.putIfAbsent(key, () => []).add(candidate);
    }

    OcrCandidate? bestCandidate;
    double maxGroupScore = -1.0;

    final bool hasValidCandidate =
        groups.values.any((list) => validator(list.first.value));

    groups.forEach((key, candidatesInGroup) {
      final sample = candidatesInGroup.first;
      final bool passesValidation = validator(sample.value);

      if (hasValidCandidate && !passesValidation) return;

      final scored = CandidateScorer.scoreCandidate(
        candidate: sample,
        passesStructuralValidation: passesValidation,
        crossPassOccurrenceCount: candidatesInGroup.length,
        totalPassesCount: validPool.length,
      );

      if (scored.score > maxGroupScore) {
        maxGroupScore = scored.score;
        bestCandidate = scored;
      }
    });

    if (bestCandidate == null ||
        (!hasValidCandidate && !validator(bestCandidate!.value))) {
      return KtpField(value: '', confidence: 0.0, source: 'none');
    }

    // Determine low confidence
    final bool isLowConf = bestCandidate!.score < lowConfidenceThreshold;

    return KtpField(
      value: bestCandidate!.value,
      confidence: bestCandidate!.score,
      corrected: bestCandidate!.corrected || isLowConf,
      source: bestCandidate!.source,
    );
  }

  /// Consolidates multiple KtpResults (for backwards compatibility if needed)
  KtpResult consolidate(List<KtpResult> passes) {
    if (passes.isEmpty) return KtpResult();
    return passes.first;
  }
}
