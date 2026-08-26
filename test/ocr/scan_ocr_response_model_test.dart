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
            "quality": {
              "score": 0.92,
              "sharpness": 0.88,
              "brightness": 0.85
            }
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

    test('Correctly parses OCR response when data_ocr contains explicit success boolean', () {
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
      expect(response.data!.dataOcr.data!['nik']?.value, equals("3273012345678901"));
    });
  });
}
