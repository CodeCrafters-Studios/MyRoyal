import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/parsers/name_parser.dart';

void main() {
  group('NameParser Tests', () {
    test('Preserves multi-word names with initials like ALGHANY K without corruption', () {
      final rawText = 'NAMA : ALGHANY K';
      final candidate = NameParser.parse(rawText, 'test');

      expect(candidate.value, equals('ALGHANY K'));
      expect(candidate.structurallyValid, isTrue);
      expect(candidate.score, greaterThanOrEqualTo(75.0));
    });

    test('Strips leading colons and symbol noise while keeping uppercase letters', () {
      final rawText = ': JANE DOE #123';
      final candidate = NameParser.parse(rawText, 'test');

      expect(candidate.value, equals('JANE DOE'));
      expect(candidate.structurallyValid, isTrue);
    });
  });
}
