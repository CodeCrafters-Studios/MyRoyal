import '../models/ocr_candidate.dart';

class CandidateScorer {
  /// Evaluates and calculates a comprehensive evidence score for an OCR candidate.
  /// Mobile local confidence is capped at [maxMobileConfidence] (default 90.0%)
  /// so that 100% confidence is reserved strictly for backend-refined OCR results.
  static OcrCandidate scoreCandidate({
    required OcrCandidate candidate,
    required bool passesStructuralValidation,
    int crossPassOccurrenceCount = 1,
    int totalPassesCount = 1,
    double roiAlignmentScore = 1.0,
    double maxMobileConfidence = 90.0,
  }) {
    if (candidate.value.isEmpty) {
      return candidate.copyWith(score: 0.0, structurallyValid: false);
    }

    double baseScore = candidate.score;

    if (candidate.mlKitConfidence != null && candidate.mlKitConfidence! > 0) {
      baseScore = candidate.mlKitConfidence!;
    }

    // Structural Validation penalty if invalid
    if (!passesStructuralValidation) {
      baseScore = baseScore > 35.0 ? 35.0 : baseScore;
    }

    final finalScore = baseScore.clamp(0.0, maxMobileConfidence);

    return candidate.copyWith(
      score: finalScore,
      structurallyValid: passesStructuralValidation,
    );
  }
}
