import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_request_model.dart';

void main() {
  SaveEmployeeOsRequestModel createRequest({required String? fileKtp}) =>
      SaveEmployeeOsRequestModel(
        id: 175,
        idCard: '3204281233294005',
        fullName: 'Abdur Sidiq',
        religionId: 1,
        bloodType: 'O',
        joinDate: '2028-08-03',
        isManufacturing: true,
        isDirect: true,
        fileKtp: fileKtp,
      );

  test('serializes the KTP image as file_ktp', () {
    expect(createRequest(fileKtp: 'aGVsbG8=').toJson()['file_ktp'], 'aGVsbG8=');
  });

  test('serializes a missing KTP image as null', () {
    expect(createRequest(fileKtp: null).toJson()['file_ktp'], isNull);
  });
}
