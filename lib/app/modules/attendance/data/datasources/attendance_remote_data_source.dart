import 'package:iroyal/app/modules/attendance/data/models/attendance_record_model.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceTodayModel> getAttendanceToday();
  Future<void> recordAttendance(AttendanceRecordModel model);
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  AttendanceRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<AttendanceTodayModel> getAttendanceToday() async {
    try {
      final r = await httpService.request(
        withToken: true,
        endpoint: 'myroyalattendance/today',
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

      if (r['data'] == null) {
        throw ApiException('Attendance data empty');
      }

      final response = AttendanceTodayModel.fromJson(r['data']);
      return response;
    } on ApiException catch (e) {
      AppUtils.logApp('CATCH ERR ::: ${e.message}');
      throw ApiException(e.message ?? 'An error occurred');
    } catch (e, stackTrace) {
      AppUtils.logApp('Error parsing JSON: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> recordAttendance(AttendanceRecordModel model) async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'myroyalattendance/record_attendance',
      method: Method.POST,
      params: model.toJson(),
      showPopUp: true,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    if (r['code'] != 200) {
      throw ApiException(r['message'] ?? 'Unknown error');
    }
  }
}
