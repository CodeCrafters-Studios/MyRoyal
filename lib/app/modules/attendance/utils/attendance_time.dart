import 'package:intl/intl.dart';

/// Pure time helpers for attendance. The backend sends wall-clock
/// `HH:mm:ss` strings plus an attendance `date`; these helpers turn them into
/// consistent [DateTime]s so durations never go negative because of stale or
/// mis-anchored values.

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

/// Parses a backend `HH:mm:ss` value onto [baseDate].
///
/// Returns null for null, empty or malformed input. When [notBefore] is given
/// and the parsed value is earlier by more than [rolloverThreshold], it is
/// moved to the next day (the event happened after midnight relative to the
/// attendance date, e.g. a night shift or the server clock after a date
/// boundary). Smaller gaps are treated as clock skew and left as-is, since
/// some timestamps are recorded with the device clock.
DateTime? parseServerClock(
  String? hhmmss,
  DateTime baseDate, {
  DateTime? notBefore,
  Duration rolloverThreshold = const Duration(hours: 1),
}) {
  if (hhmmss == null || hhmmss.trim().isEmpty) return null;

  final DateTime parsed;
  try {
    parsed = DateFormat('HH:mm:ss').parseStrict(hhmmss.trim());
  } catch (_) {
    return null;
  }

  var result = DateTime(
    baseDate.year,
    baseDate.month,
    baseDate.day,
    parsed.hour,
    parsed.minute,
    parsed.second,
  );

  if (notBefore != null && notBefore.difference(result) > rolloverThreshold) {
    result = result.add(const Duration(days: 1));
  }
  return result;
}

/// Worked time between [checkIn] and [end] minus break time. Never negative.
///
/// A completed break ([breakStart] + [breakEnd]) is subtracted. A running
/// break ([onBreak] with only [breakStart]) is subtracted up to [end].
Duration computeWorkDuration({
  required DateTime checkIn,
  required DateTime end,
  DateTime? breakStart,
  DateTime? breakEnd,
  bool onBreak = false,
}) {
  var worked = _nonNegative(end.difference(checkIn));

  if (breakStart != null && breakEnd != null) {
    worked -= _nonNegative(breakEnd.difference(breakStart));
  } else if (onBreak && breakStart != null) {
    worked -= _nonNegative(end.difference(breakStart));
  }

  return _nonNegative(worked);
}

/// Formats as `HHh MMm`; negative durations are shown as zero.
String formatHoursMinutes(Duration d) {
  final safe = _nonNegative(d);
  String two(int n) => n.toString().padLeft(2, '0');
  return '${two(safe.inHours)}h ${two(safe.inMinutes.remainder(60))}m';
}

Duration _nonNegative(Duration d) => d.isNegative ? Duration.zero : d;
