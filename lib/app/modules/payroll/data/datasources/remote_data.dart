import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_download_url_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class PayrollRemoteDataSources {
  Future<PayrollPeriodModel> getPayrollPeriod();
  Future<PayrollDownloadUrlModel> payrollDownloadUrl(
    Map<String, dynamic> params,
  );
  Future<PayrollDataOverviewModel> payrollDataOverview(
    Map<String, dynamic> params,
  );
}

class PayrollRemoteDataSourcesImpl implements PayrollRemoteDataSources {
  PayrollRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<PayrollPeriodModel> getPayrollPeriod() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'payroll/getActivePayroll',
        method: Method.GET,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }

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
  Future<PayrollDownloadUrlModel> payrollDownloadUrl(
      Map<String, dynamic> params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'payroll/downloadSlip',
        params: params,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }

      final response = PayrollDownloadUrlModel.fromJson(r);
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
  Future<PayrollDataOverviewModel> payrollDataOverview(
      Map<String, dynamic> params) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'payroll/viewPayroll',
        params: params,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
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
