import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/parsers/nik_candidate_generator.dart';

void main() {
  group('NikCandidateGenerator Tests', () {
    test('Correctly generates 16-digit candidate from OCR text with character substitutions', () {
      final rawTexts = ['NIK : 3273G1234567890I'];
      final candidates = NikCandidateGenerator.generateCandidates(
        rawTexts: rawTexts,
        sourceName: 'test',
      );

      expect(candidates, isNotEmpty);
      final topCandidate = candidates.firstWhere((c) => c.structurallyValid);
      expect(topCandidate.value, equals('3273612345678901'));
      expect(topCandidate.value.length, equals(16));
      expect(topCandidate.score, greaterThanOrEqualTo(75.0));
    });

    test('Rejects incomplete NIK string (10-15 digits) from high structural score', () {
      final rawTexts = ['3273012345678']; // 13 digits
      final candidates = NikCandidateGenerator.generateCandidates(
        rawTexts: rawTexts,
        sourceName: 'test',
      );

      for (final c in candidates) {
        expect(c.structurallyValid, isFalse);
        expect(c.score, lessThan(50.0));
      }
    });

    test('Handles multiple OCR substitution variants (O->0, B->8, S->5, Z->2, E->3, D->0)', () {
      final rawTexts = ['3273O123B56S7Z3D'];
      final candidates = NikCandidateGenerator.generateCandidates(
        rawTexts: rawTexts,
        sourceName: 'test',
      );

      final validCandidate = candidates.firstWhere((c) => c.structurallyValid);
      expect(validCandidate.value, equals('3273012385657230'));
    });
  });
}
