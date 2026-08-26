import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/models/ktp_result.dart';
import 'package:MyRoyal/app/modules/ocr/services/ktp_validator.dart';

void main() {
  group('KtpValidator Tests', () {
    test('Validates complete and correct KtpResult', () {
      final result = KtpResult()
        ..nik = KtpField(value: '3273012345678901')
        ..name = KtpField(value: 'ALGHANY KENNEDY')
        ..birthPlace = KtpField(value: 'BANDUNG')
        ..birthDate = KtpField(value: '12-03-1998')
        ..gender = KtpField(value: 'LAKI-LAKI')
        ..address = KtpField(value: 'JL MERDEKA NO 10')
        ..rt = KtpField(value: '001')
        ..rw = KtpField(value: '002')
        ..village = KtpField(value: 'CITARUM')
        ..district = KtpField(value: 'BANDUNG WETAN')
        ..city = KtpField(value: 'KOTA BANDUNG')
        ..province = KtpField(value: 'JAWA BARAT')
        ..religion = KtpField(value: 'ISLAM')
        ..maritalStatus = KtpField(value: 'BELUM KAWIN')
        ..work = KtpField(value: 'KARYAWAN SWASTA')
        ..nationality = KtpField(value: 'WNI');

      final validation = KtpValidator.validate(result);
      expect(validation.isValid, isTrue);
      expect(validation.invalidFields, isEmpty);
    });

    test('Identifies invalid NIK and Date fields correctly', () {
      final result = KtpResult()
        ..nik = KtpField(value: '12345') // Invalid NIK length
        ..name = KtpField(value: 'TEST NAME')
        ..birthDate = KtpField(value: '31-02-2000') // Invalid date
        ..gender = KtpField(value: 'LAKI-LAKI')
        ..rt = KtpField(value: '001')
        ..rw = KtpField(value: '002')
        ..province = KtpField(value: 'JAWA BARAT')
        ..religion = KtpField(value: 'ISLAM')
        ..nationality = KtpField(value: 'WNI');

      final validation = KtpValidator.validate(result);
      expect(validation.isValid, isFalse);
      expect(validation.invalidFields, contains('NIK'));
      expect(validation.invalidFields, contains('Tanggal Lahir'));
    });
  });
}
