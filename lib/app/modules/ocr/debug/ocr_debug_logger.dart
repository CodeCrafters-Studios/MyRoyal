import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../models/ocr_candidate.dart';
import '../models/ktp_field_regions.dart';

class OcrDebugLogger {
  static bool debugMode = kDebugMode;

  static void logImageNormalization({
    required String originalPath,
    required String normalizedPath,
    required int width,
    required int height,
  }) {
    if (!debugMode) return;
    developer.log('=== KTP OCR DEBUG: IMAGE NORMALIZATION ===');
    developer.log('Original Path: $originalPath');
    developer.log('Normalized Path: $normalizedPath');
    developer.log('Canonical Resolution: ${width}x$height');
  }

  static void logFieldOcr({
    required String fieldName,
    required NormalizedRect roi,
    required List<String> rawTexts,
    required List<OcrCandidate> candidates,
    required String finalSelectedValue,
    required double finalConfidence,
  }) {
    if (!debugMode) return;

    final StringBuffer sb = StringBuffer();
    sb.writeln('\n[$fieldName]');
    sb.writeln('ROI: $roi');
    sb.writeln('RAW:');
    for (final raw in rawTexts) {
      sb.writeln('  "$raw"');
    }
    sb.writeln('CANDIDATES:');
    for (final cand in candidates) {
      sb.writeln(
          '  "${cand.value}" score=${cand.score.toStringAsFixed(1)} (src: ${cand.source}, valid: ${cand.structurallyValid})');
    }
    sb.writeln('FINAL:');
    sb.writeln(
        '  "$finalSelectedValue" confidence=${finalConfidence.toStringAsFixed(1)}');

    developer.log(sb.toString());
  }

  static void logPipelineCompletion(String summary) {
    if (!debugMode) return;
    developer.log('=== KTP OCR PIPELINE SUCCESS ===\n$summary');
  }
}
