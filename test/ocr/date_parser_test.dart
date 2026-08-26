import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/parsers/date_parser.dart';

void main() {
  group('DateParser Tests', () {
    test('Normalizes various date formats to DD-MM-YYYY', () {
      final formats = [
        '12-03-1998',
        '12.03.1998',
        '12/03/1998',
        '12 03 1998',
      ];

      for (final fmt in formats) {
        final candidate = DateParser.parseDate(fmt, 'test');
        expect(candidate.value, equals('12-03-1998'), reason: 'Failed for format: $fmt');
        expect(candidate.structurallyValid, isTrue);
      }
    });

    test('Rejects invalid calendar dates', () {
      final invalidDates = [
        '31-02-1998', // Feb 31
        '32-01-2000', // Day 32
        '15-13-1995', // Month 13
        '10-10-1850', // Year too old
      ];

      for (final dateStr in invalidDates) {
        final candidate = DateParser.parseDate(dateStr, 'test');
        expect(candidate.structurallyValid, isFalse, reason: 'Accepted invalid date: $dateStr');
      }
    });

    test('Parses Tempat Lahir and Tanggal Lahir combined string', () {
      final input = 'TEMPAT/TGL LAHIR : JAKARTA, 12-03-1998';
      final result = DateParser.parseBirthPlaceAndDate(input, 'test');

      expect(result['birthPlace']!.value, equals('JAKARTA'));
      expect(result['birthDate']!.value, equals('12-03-1998'));
      expect(result['birthDate']!.structurallyValid, isTrue);
    });
  });
}
