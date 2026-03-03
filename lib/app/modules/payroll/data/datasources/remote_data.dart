import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class PayrollRemoteDataSources {
  Future<PayrollPeriodModel> getPayrollPeriod();
  Future<void> payrollDownloadUrl(Map<String, dynamic> params);
  Future<PayrollDataOverviewModel> payrollDataOverview(
      Map<String, dynamic> params);
}

class PayrollRemoteDataSourcesImpl implements PayrollRemoteDataSources {
  PayrollRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<PayrollPeriodModel> getPayrollPeriod() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'payroll/getActivePayroll',
        method: Method.GET,
        showPopUp: true,
      );
      final response = PayrollPeriodModel.fromJson(r);
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
  Future<void> payrollDownloadUrl(Map<String, dynamic> params) async {
    AppUtils.logApp('PARAMS $params');
    try {
      await httpService.downloadFilePost(
        endpoint: 'payroll/downloadSlip',
        fileName: '${params["filename"]}.pdf',
        body: params,
      );
    } on ServerFailure {
      throw ApiException('Server error occurred');
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      rethrow;
    } catch (e) {
      AppUtils.logApp('Download error: $e');
      throw ApiException(e.toString());
    }
  }

  @override
  Future<PayrollDataOverviewModel> payrollDataOverview(
      Map<String, dynamic> params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'payroll/viewPayroll',
        params: params,
        showPopUp: true,
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final response = PayrollDataOverviewModel.fromJson(r);
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
}
