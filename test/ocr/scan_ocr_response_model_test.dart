import 'package:flutter_test/flutter_test.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';

void main() {
  group('ScanOcrResponseModel JSON Parsing Tests', () {
    test('Correctly parses successful OCR response with different = true', () {
      final jsonResponse = {
        "code": 200,
        "message": "Data OCR berhasil diproses",
        "data": {
          "id": 15,
          "data_ocr": {
            "data": {
              "nik": {
                "value": "3171012345678901",
                "confidence": 0.99,
                "source": "ocr"
              },
              "nama": {
                "value": "JOHN DOE",
                "confidence": 0.95,
                "source": "ocr"
              },
              "tempat_lahir": {
                "value": "JAKARTA",
                "confidence": 0.90,
                "source": "ocr"
              },
              "tanggal_lahir": {
                "value": "15-05-1990",
                "confidence": 0.92,
                "source": "ocr"
              },
              "jenis_kelamin": {
                "value": "LAKI-LAKI",
                "confidence": 0.98,
                "source": "ocr"
              }
            },
            "quality": {"score": 0.92, "sharpness": 0.88, "brightness": 0.85}
          },
          "different": true
        }
      };

      final response = ScanOcrResponseModel.fromJson(jsonResponse);

      expect(response.code, equals(200));
      expect(response.data, isNotNull);
      expect(response.data!.different, isTrue);
      expect(response.data!.dataOcr.success, isTrue);
      expect(response.success, isTrue);

      final ocrData = response.data!.dataOcr.data;
      expect(ocrData, isNotNull);
      expect(ocrData!['nik']?.value, equals("3171012345678901"));
      expect(ocrData['nama']?.value, equals("JOHN DOE"));
      expect(ocrData['tempat_lahir']?.value, equals("JAKARTA"));
    });

    test(
        'Correctly parses OCR response when data_ocr contains explicit success boolean',
        () {
      final jsonResponse = {
        "code": 200,
        "message": "Success",
        "data": {
          "id": 20,
          "data_ocr": {
            "success": true,
            "data": {
              "nik": {
                "value": "3273012345678901",
                "confidence": 1.0,
                "source": "ocr"
              }
            }
          },
          "different": false
        }
      };

      final response = ScanOcrResponseModel.fromJson(jsonResponse);

      expect(response.code, equals(200));
      expect(response.data!.different, isFalse);
      expect(response.data!.dataOcr.success, isTrue);
      expect(response.data!.dataOcr.data!['nik']?.value,
          equals("3273012345678901"));
    });

    test('Parses manufacturing and direct flags from data_ocr', () {
      final jsonResponse = {
        "code": 200,
        "message": "Success",
        "data": {
          "id": 13,
          "data_ocr": {
            "id_card": "3217061202990002",
            "is_direct": true,
            "is_manufacturing": false
          },
          "different": true
        }
      };

      final response = ScanOcrResponseModel.fromJson(jsonResponse);

      expect(response.data!.dataOcr.isDirect, isTrue);
      expect(response.data!.dataOcr.isManufacturing, isFalse);
    });

    test('Keeps unset manufacturing and direct flags null', () {
      final jsonResponse = {
        "code": 200,
        "message": "Success",
        "data": {
          "id": 13,
          "data_ocr": {
            "id_card": "3217061202990002",
            "is_direct": null,
            "is_manufacturing": null
          },
          "different": true
        }
      };

      final response = ScanOcrResponseModel.fromJson(jsonResponse);

      expect(response.data!.dataOcr.isDirect, isNull);
      expect(response.data!.dataOcr.isManufacturing, isNull);
    });

    test('Parses HRMS data when data_ocr is null', () {
      final response = ScanOcrResponseModel.fromJson({
        "code": 200,
        "message": "Data OCR berhasil didapat!.",
        "data": {
          "id": 13,
          "data_ocr": null,
          "data_inputed_os": {
            "no_registration": "GMBI5655",
            "first_name": "Test",
            "last_name": "Keempat",
            "birthplace": "Jakarta",
            "date_of_birth": "1991-11-11",
            "marital_status": "0",
            "gender": "1",
            "smoker": false,
            "id_card": "3204289716381003",
            "religion_id": "4",
            "blood_type": "O-",
            "main_skill": 134,
            "additional_skill": ["153"],
            "is_direct": null,
            "is_manufacturing": null
          },
          "different": false
        }
      });

      final hrData = response.data!.dataInputOsModel!;
      expect(response.code, 200);
      expect(response.success, isTrue);
      expect(response.data!.dataOcr.data, isNull);
      expect(hrData.firstName, "Test");
      expect(hrData.lastName, "Keempat");
      expect(hrData.dateOfBirth, DateTime(1991, 11, 11));
      expect(hrData.idCard, "3204289716381003");
      expect(hrData.mainSkill, 134);
      expect(hrData.additionalSkill, ["153"]);
    });
  });
}
