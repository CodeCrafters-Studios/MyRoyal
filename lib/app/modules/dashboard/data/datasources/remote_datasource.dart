import 'package:iroyal/app/modules/dashboard/data/models/dashboard_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_late_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_permit_request_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_special_leave_request_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class DashboardRemoteDataSource {
  Future<DashboardModel> getDashboard();
  Future<DetailSpecialLeaveRequestModel> getDetailSpecialLeaveRequest();
  Future<DetailLateModel> getDetailLate();
  Future<DetailPermitRequestModel> getDetailPermitRequest();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  DashboardRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<DashboardModel> getDashboard() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'dashboard/index',
        method: Method.GET,
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

      final response = DashboardModel.fromJson(r);
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
  Future<DetailSpecialLeaveRequestModel> getDetailSpecialLeaveRequest() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'dashboard/getData',
        method: Method.GET,
        showPopUp: true,
        params: {"type": "specialLeave"},
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final response = DetailSpecialLeaveRequestModel.fromJson(r);
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
  Future<DetailLateModel> getDetailLate() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'dashboard/getData',
        method: Method.GET,
        showPopUp: true,
        params: {"type": "lateAttendance"},
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final response = DetailLateModel.fromJson(r);
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
  Future<DetailPermitRequestModel> getDetailPermitRequest() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'dashboard/getData',
        method: Method.GET,
        showPopUp: true,
        params: {"type": "permitRequest"},
      );
      if (r == null) {
        throw ApiException('No response from server');
      }

      final code = r['code'];
      final message = r['message'] ?? 'Unknown error occurred';

      if (code != 200) {
        throw ApiException(message);
      }

      final response = DetailPermitRequestModel.fromJson(r);
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
