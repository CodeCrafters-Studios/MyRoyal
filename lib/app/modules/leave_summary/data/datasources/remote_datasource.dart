import 'package:iroyal/app/modules/leave_summary/data/models/cancel_form_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/create_form_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/create_form_permit_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/permit_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/subtitute_employee_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_permit_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class LeaveRemoteDataSources {
  Future<LeaveModel> getLeave();
  Future<SubtituteEmployeeEntity> getSubtituteEmployee();
  Future<CreateFormLeaveEntity> createFormLeave(
    Map<String, dynamic> createFormLeaveParams,
  );
  Future<CancelFormLeaveEntity> cancelFormLeave(
    Map<String, dynamic> cancelFormLeaveParams,
  );
  Future<CreateFormPermitEntity> createFormPermit(
    Map<String, dynamic> createFormPermitParams,
  );
  Future<PermitModel> getPermit();
}

class LeaveRemoteDataSourcesImpl implements LeaveRemoteDataSources {
  LeaveRemoteDataSourcesImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<LeaveModel> getLeave() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/getDataLeave',
        method: Method.GET,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = LeaveModel.fromJson(r);
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
  Future<SubtituteEmployeeEntity> getSubtituteEmployee() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/getDataForm',
        method: Method.GET,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = SubtituteEmployeeModel.fromJson(r["data"]);
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
  Future<CreateFormLeaveEntity> createFormLeave(
      Map<String, dynamic> createFormLeaveParams) async {
    try {
      AppUtils.logApp('PARAMS ::: $createFormLeaveParams');
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/submission',
        params: createFormLeaveParams,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = CreateFormLeaveModel.fromJson(r["data"]);
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
  Future<CancelFormLeaveEntity> cancelFormLeave(
      Map<String, dynamic> cancelFormLeaveParams) async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/approval',
        params: cancelFormLeaveParams,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = CancelFormLeaveModel.fromJson(r["data"]);
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
  Future<CreateFormPermitEntity> createFormPermit(
      Map<String, dynamic> createFormPermitParams) async {
    try {
      AppUtils.logApp('PARAMS ::: $createFormPermitParams');
      final r = await httpService.request(
        withToken: true,
        enpoint: 'attendance/submissionPermit',
        params: createFormPermitParams,
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = CreateFormPermitModel.fromJson(r["data"]);
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
  Future<PermitModel> getPermit() async {
    try {
      final r = await httpService.request(
        withToken: true,
        enpoint: 'dashboard/getData',
        method: Method.GET,
        params: {"type": "permitRequest"},
        showPopUp: true,
      );
      if (r['code'] != 200) {
        throw ApiException(r['message']);
      }
      final response = PermitModel.fromJson(r);
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
