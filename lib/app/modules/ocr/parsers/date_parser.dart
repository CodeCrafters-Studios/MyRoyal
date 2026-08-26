import '../models/ocr_candidate.dart';

class DateParser {
  /// Extract and validate date string from raw OCR input.
  /// Accepts formats: DD-MM-YYYY, DD.MM.YYYY, DD/MM/YYYY, DD MM YYYY.
  /// Normalizes to standard application format "DD-MM-YYYY".
  static OcrCandidate parseDate(String rawText, String sourceName,
      {double? mlKitConfidence}) {
    if (rawText.trim().isEmpty) {
      return OcrCandidate(
          value: '', score: 0.0, source: sourceName, structurallyValid: false);
    }

    String cleaned = rawText
        .replaceAll('O', '0')
        .replaceAll('o', '0')
        .replaceAll('I', '1')
        .replaceAll('l', '1');

    // Regex matching DD [./- ] MM [./- ] YYYY
    final dateRegExp = RegExp(
        r'(\b[0-3]?[0-9])[\.\/\-\s]+([0-1]?[0-9])[\.\/\-\s]+((?:19|20)\d{2})\b');
    final match = dateRegExp.firstMatch(cleaned);

    if (match != null) {
      final int day = int.parse(match.group(1)!);
      final int month = int.parse(match.group(2)!);
      final int year = int.parse(match.group(3)!);

      if (_isValidCalendarDate(day, month, year)) {
        final formattedDay = day.toString().padLeft(2, '0');
        final formattedMonth = month.toString().padLeft(2, '0');
        final formattedDate = '$formattedDay-$formattedMonth-$year';

        final double score = (mlKitConfidence != null && mlKitConfidence > 0)
            ? mlKitConfidence.clamp(0.0, 90.0)
            : 84.0;

        return OcrCandidate(
          value: formattedDate,
          score: score,
          source: sourceName,
          mlKitConfidence: mlKitConfidence,
          structurallyValid: true,
          corrected: rawText.trim() != formattedDate,
        );
      }
    }

    return OcrCandidate(
      value: '',
      score: 0.0,
      source: sourceName,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: false,
    );
  }

  /// Parses Tempat Lahir & Tanggal Lahir combined string if given in format "JAKARTA, 12-03-1998"
  static Map<String, OcrCandidate> parseBirthPlaceAndDate(
      String rawText, String sourceName,
      {double? mlKitConfidence}) {
    String clean = rawText.trim();
    // Strip common leading labels
    clean = clean
        .replaceAll(
            RegExp(r'^(TEMPAT|TGL|LAHIR|[\/\s:]+)+', caseSensitive: false), '')
        .trim();
    if (clean.startsWith(':')) clean = clean.substring(1).trim();

    String place = '';
    String dateStr = '';

    if (clean.contains(',')) {
      final parts = clean.split(',');
      place = parts.first.replaceAll(RegExp(r'[^a-zA-Z\s]'), '').trim();
      dateStr = parts.sublist(1).join(' ').trim();
    } else {
      dateStr = clean;
    }

    final dateCandidate = parseDate(
        dateStr.isNotEmpty ? dateStr : clean, sourceName,
        mlKitConfidence: mlKitConfidence);

    // Clean birth place
    place = place.replaceAll(RegExp(r'[^a-zA-Z\s]'), '').toUpperCase().trim();
    final bool isPlaceValid =
        place.length >= 2 && RegExp(r'^[A-Z\s]+$').hasMatch(place);

    final placeCandidate = OcrCandidate(
      value: place,
      score: isPlaceValid
          ? (mlKitConfidence != null && mlKitConfidence > 0
              ? mlKitConfidence.clamp(0.0, 90.0)
              : 81.5)
          : 20.0,
      source: sourceName,
      mlKitConfidence: mlKitConfidence,
      structurallyValid: isPlaceValid,
    );

    return {
      'birthPlace': placeCandidate,
      'birthDate': dateCandidate,
    };
  }

  static bool _isValidCalendarDate(int day, int month, int year) {
    final currentYear = DateTime.now().year;
    if (year < 1900 || year > currentYear) return false;
    if (month < 1 || month > 12) return false;
    if (day < 1 || day > 31) return false;

    // Check days in month considering leap years
    final daysInMonth = [
      0,
      31,
      _isLeapYear(year) ? 29 : 28,
      31,
      30,
      31,
      30,
      31,
      31,
      30,
      31,
      30,
      31
    ];
    return day <= daysInMonth[month];
  }

  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
