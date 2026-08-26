class OcrCandidate {
  final String value;
  final double score;
  final String source;
  final double? mlKitConfidence;
  final bool structurallyValid;
  final bool corrected;

  const OcrCandidate({
    required this.value,
    required this.score,
    required this.source,
    this.mlKitConfidence,
    this.structurallyValid = true,
    this.corrected = false,
  });

  OcrCandidate copyWith({
    String? value,
    double? score,
    String? source,
    double? mlKitConfidence,
    bool? structurallyValid,
    bool? corrected,
  }) {
    return OcrCandidate(
      value: value ?? this.value,
      score: score ?? this.score,
      source: source ?? this.source,
      mlKitConfidence: mlKitConfidence ?? this.mlKitConfidence,
      structurallyValid: structurallyValid ?? this.structurallyValid,
      corrected: corrected ?? this.corrected,
    );
  }

  @override
  String toString() {
    return 'OcrCandidate(value: "$value", score: ${score.toStringAsFixed(1)}, source: $source, mlKitConf: $mlKitConfidence, valid: $structurallyValid, corrected: $corrected)';
  }
}
