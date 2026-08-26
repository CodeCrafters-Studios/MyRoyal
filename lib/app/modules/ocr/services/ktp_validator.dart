import '../models/ktp_result.dart';
import '../utils/ktp_dictionaries.dart';
import '../parsers/date_parser.dart';

class KtpValidationResult {
  final bool isValid;
  final bool isNikValid;
  final bool isNameValid;
  final bool isGenderValid;
  final bool isRtRwValid;
  final bool isProvinceValid;
  final bool isReligionValid;
  final bool isNationalityValid;
  final bool isDateValid;
  final List<String> invalidFields;

  const KtpValidationResult({
    required this.isValid,
    required this.isNikValid,
    required this.isNameValid,
    required this.isGenderValid,
    required this.isRtRwValid,
    required this.isProvinceValid,
    required this.isReligionValid,
    required this.isNationalityValid,
    required this.isDateValid,
    required this.invalidFields,
  });

  @override
  String toString() {
    return 'KtpValidationResult(valid: $isValid, invalidFields: $invalidFields)';
  }
}

class KtpValidator {
  static KtpValidationResult validate(KtpResult result) {
    final isNikValid = validateNik(result.nik.value);
    final isNameValid = validateName(result.name.value);
    final isGenderValid = validateGender(result.gender.value);
    final isRtRwValid = validateRtRw(result.rt.value, result.rw.value);
    final isProvinceValid = validateProvince(result.province.value);
    final isReligionValid = validateReligion(result.religion.value);
    final isNationalityValid = validateNationality(result.nationality.value);
    final isDateValid = validateDate(result.birthDate.value);

    List<String> invalidFields = [];
    if (!isNikValid) invalidFields.add('NIK');
    if (!isNameValid) invalidFields.add('Nama Lengkap');
    if (!isGenderValid) invalidFields.add('Jenis Kelamin');
    if (!isRtRwValid) invalidFields.add('RT/RW');
    if (!isProvinceValid) invalidFields.add('Provinsi');
    if (!isReligionValid) invalidFields.add('Agama');
    if (!isNationalityValid) invalidFields.add('Kewarganegaraan');
    if (!isDateValid) invalidFields.add('Tanggal Lahir');

    final bool overallValid = invalidFields.isEmpty;

    return KtpValidationResult(
      isValid: overallValid,
      isNikValid: isNikValid,
      isNameValid: isNameValid,
      isGenderValid: isGenderValid,
      isRtRwValid: isRtRwValid,
      isProvinceValid: isProvinceValid,
      isReligionValid: isReligionValid,
      isNationalityValid: isNationalityValid,
      isDateValid: isDateValid,
      invalidFields: invalidFields,
    );
  }

  static bool validateNik(String nik) {
    return nik.length == 16 && RegExp(r'^\d{16}$').hasMatch(nik);
  }

  static bool validateName(String name) {
    final clean = name.trim();
    return clean.length >= 2 &&
        clean.length <= 50 &&
        RegExp(r"^[a-zA-Z\s\.']+$").hasMatch(clean);
  }

  static bool validateGender(String gender) {
    return KtpDictionaries.genders.contains(gender.trim().toUpperCase());
  }

  static bool validateRtRw(String rt, String rw) {
    final bool rtValid = rt.length == 3 && RegExp(r'^\d{3}$').hasMatch(rt);
    final bool rwValid = rw.length == 3 && RegExp(r'^\d{3}$').hasMatch(rw);
    return rtValid && rwValid;
  }

  static bool validateProvince(String province) {
    return KtpDictionaries.provinces.contains(province.trim().toUpperCase());
  }

  static bool validateReligion(String religion) {
    return KtpDictionaries.religions.contains(religion.trim().toUpperCase());
  }

  static bool validateNationality(String nationality) {
    return KtpDictionaries.nationalities
        .contains(nationality.trim().toUpperCase());
  }

  static bool validateDate(String dateStr) {
    if (dateStr.isEmpty) return false;
    final candidate = DateParser.parseDate(dateStr, 'validator');
    return candidate.structurallyValid;
  }
}
