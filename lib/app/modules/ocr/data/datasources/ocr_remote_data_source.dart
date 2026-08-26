import 'package:MyRoyal/app/modules/ocr/data/models/data_master_employee_os_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/models/employee_os_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';

abstract class OcrRemoteDataSource {
  Future<ScanOcrResponseModel> scanOcr(ScanOcrRequestModel request);
  Future<EmployeeOsModel> getEmployeeOs(params);
  Future<DataMasterEmployeeOsModel> getDataMasterEmployeeOs();
  Future<SaveEmployeeOsResponseModel> saveEmployeeOs(
      SaveEmployeeOsRequestModel request);
}

class OcrRemoteDataSourceImpl implements OcrRemoteDataSource {
  final HttpService httpService;

  OcrRemoteDataSourceImpl({required this.httpService});

  @override
  Future<ScanOcrResponseModel> scanOcr(ScanOcrRequestModel request) async {
    try {
      final formData = await request.toFormData();
      final r = await httpService.multipart(
        endpoint: 'employeeos/scanocr',
        formData: formData,
        withToken: true,
      );
      return ScanOcrResponseModel.fromJson(r);
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR OCR API ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred while scanning OCR');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error in scanOcr: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<EmployeeOsModel> getEmployeeOs(params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'employeeos/list_data/waiting',
        params: {'page': params},
        method: Method.GET,
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final response = EmployeeOsModel.fromJson(r['data']);
      return response;
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<DataMasterEmployeeOsModel> getDataMasterEmployeeOs() async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'employeeos/data_master',
      method: Method.GET,
    );
    if (r == null) {
      throw ApiException('No response from server');
    }

    final code = r['code'];
    final message = r['message'] ?? 'Unknown error occurred';

    if (code != 200) {
      throw ApiException(message);
    }

    if (r['data'] == null) {
      throw ApiException('Data Master Employee OS empty');
    }

    final response = DataMasterEmployeeOsModel.fromJson(r['data']);
    return response;
  }

  @override
  Future<SaveEmployeeOsResponseModel> saveEmployeeOs(
      SaveEmployeeOsRequestModel request) async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'employeeos/savedata',
      params: request.toJson(),
      method: Method.POST,
    );
    if (r == null) {
      throw ApiException('No response from server');
    }

    final response = SaveEmployeeOsResponseModel.fromJson(r);
    if (!response.success) {
      throw ApiException(response.message.isEmpty
          ? 'Gagal menyimpan data Employee OS'
          : response.message);
    }
    return response;
  }
}
