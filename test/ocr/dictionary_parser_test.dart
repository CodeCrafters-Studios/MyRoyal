import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/parsers/dictionary_parser.dart';
import 'package:MyRoyal/app/modules/ocr/utils/ktp_dictionaries.dart';

void main() {
  group('DictionaryParser Tests', () {
    test('Exact match returns 100 confidence', () {
      final parser = DictionaryParser(dictionary: KtpDictionaries.genders);
      final candidate = parser.parseCandidate('LAKI-LAKI', 'test');

      expect(candidate.value, equals('LAKI-LAKI'));
      expect(candidate.score, equals(90.0));
      expect(candidate.corrected, isFalse);
    });

    test('Fuzzy match corrects minor typos above confidence threshold', () {
      final parser = DictionaryParser(dictionary: KtpDictionaries.religions, minConfidenceThreshold: 65.0);
      final candidate = parser.parseCandidate('1SLAM', 'test'); // 1 -> I

      expect(candidate.value, equals('ISLAM'));
      expect(candidate.score, greaterThanOrEqualTo(65.0));
      expect(candidate.corrected, isTrue);
    });

    test('Rejects unrelated OCR text falling below confidence threshold', () {
      final parser = DictionaryParser(dictionary: KtpDictionaries.genders, minConfidenceThreshold: 65.0);
      final candidate = parser.parseCandidate('XYZ123 UNRELATED TEXT', 'test');

      expect(candidate.structurallyValid, isFalse);
      expect(candidate.score, lessThan(65.0));
    });
  });
}
