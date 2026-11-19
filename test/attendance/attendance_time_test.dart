import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/attendance/utils/attendance_time.dart';

void main() {
  final day = DateTime(2026, 11, 19);

  group('parseServerClock', () {
    test('anchors HH:mm:ss onto the given date', () {
      expect(parseServerClock('08:15:30', day), DateTime(2026, 11, 19, 8, 15, 30));
    });

    test('null, empty and malformed values return null', () {
      expect(parseServerClock(null, day), isNull);
      expect(parseServerClock('', day), isNull);
      expect(parseServerClock('  ', day), isNull);
      expect(parseServerClock('not-a-time', day), isNull);
    });

    test('rolls to next day when earlier than notBefore', () {
      final checkIn = DateTime(2026, 11, 19, 22, 0);
      expect(
        parseServerClock('01:30:00', day, notBefore: checkIn),
        DateTime(2026, 11, 20, 1, 30),
      );
    });

    test('small clock skew does not roll to next day', () {
      final checkIn = DateTime(2026, 11, 19, 12, 2);
      expect(
        parseServerClock('12:00:00', day, notBefore: checkIn),
        DateTime(2026, 11, 19, 12, 0),
      );
    });

    test('server clock after midnight on previous-day record rolls forward', () {
      final yesterday = DateTime(2026, 11, 18);
      final checkIn = DateTime(2026, 11, 18, 8, 0);
      expect(
        parseServerClock('00:10:00', yesterday, notBefore: checkIn),
        DateTime(2026, 11, 19, 0, 10),
      );
    });

    test('does not roll when later than notBefore', () {
      final checkIn = DateTime(2026, 11, 19, 8, 0);
      expect(
        parseServerClock('17:00:00', day, notBefore: checkIn),
        DateTime(2026, 11, 19, 17, 0),
      );
    });
  });

  group('computeWorkDuration', () {
    final checkIn = DateTime(2026, 11, 19, 8, 0);

    test('plain duration without break (unchanged behaviour)', () {
      expect(
        computeWorkDuration(checkIn: checkIn, end: DateTime(2026, 11, 19, 17, 0)),
        const Duration(hours: 9),
      );
    });

    test('subtracts a completed break', () {
      expect(
        computeWorkDuration(
          checkIn: checkIn,
          end: DateTime(2026, 11, 19, 17, 0),
          breakStart: DateTime(2026, 11, 19, 12, 0),
          breakEnd: DateTime(2026, 11, 19, 13, 0),
        ),
        const Duration(hours: 8),
      );
    });

    test('subtracts a running break', () {
      expect(
        computeWorkDuration(
          checkIn: checkIn,
          end: DateTime(2026, 11, 19, 12, 30),
          breakStart: DateTime(2026, 11, 19, 12, 0),
          onBreak: true,
        ),
        const Duration(hours: 4),
      );
    });

    test('regression: stale previous-day break no longer yields -12m', () {
      // Old bug: a 60 min break from yesterday subtracted at 08:48 today.
      final d = computeWorkDuration(
        checkIn: checkIn,
        end: DateTime(2026, 11, 19, 8, 48),
        breakStart: DateTime(2026, 11, 18, 12, 0),
        breakEnd: DateTime(2026, 11, 18, 13, 0),
      );
      expect(d.isNegative, isFalse);
      expect(formatHoursMinutes(d), '00h 00m');
    });

    test('end before check-in clamps to zero', () {
      expect(
        computeWorkDuration(checkIn: checkIn, end: DateTime(2026, 11, 19, 7, 0)),
        Duration.zero,
      );
    });

    test('night shift across midnight', () {
      final nightIn = DateTime(2026, 11, 19, 22, 0);
      final out = parseServerClock('06:00:00', day, notBefore: nightIn)!;
      expect(computeWorkDuration(checkIn: nightIn, end: out), const Duration(hours: 8));
    });
  });

  group('formatHoursMinutes', () {
    test('formats hours and minutes', () {
      expect(formatHoursMinutes(const Duration(hours: 8, minutes: 5)), '08h 05m');
    });

    test('never renders a negative value', () {
      expect(formatHoursMinutes(const Duration(minutes: -12)), '00h 00m');
    });
  });
}
