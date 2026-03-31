import 'package:MyRoyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_record_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/services/http_service.dart';

abstract class AttendanceRemoteDataSource {
  Future<AttendanceTodayModel> getAttendanceToday();
  Future<void> recordAttendance(AttendanceRecordModel model);
  Future<List<AttendanceLocationModel>> getAttendanceLocation();
}

class AttendanceRemoteDataSourceImpl implements AttendanceRemoteDataSource {
  AttendanceRemoteDataSourceImpl({required this.httpService});

  final HttpService httpService;

  @override
  Future<AttendanceTodayModel> getAttendanceToday() async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'myroyalattendance/today',
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
      throw ApiException('Attendance data empty');
    }

    final response = AttendanceTodayModel.fromJson(r['data']);
    return response;
  }

  @override
  Future<void> recordAttendance(AttendanceRecordModel model) async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'myroyalattendance/record_attendance',
      method: Method.POST,
      params: model.toJson(),
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    if (r['code'] != 200) {
      throw ApiException(r['message'] ?? 'Unknown error');
    }
  }

  @override
  Future<List<AttendanceLocationModel>> getAttendanceLocation() async {
    final r = await httpService.request(
      withToken: true,
      endpoint: 'myroyalattendance/location',
      method: Method.GET,
    );

    if (r == null) {
      throw ApiException('No response from server');
    }

    if (r['code'] != 200) {
      throw ApiException(r['message'] ?? 'Unknown error');
    }

    final List<AttendanceLocationModel> response = (r['data'] as List)
        .map((x) => AttendanceLocationModel.fromJson(x))
        .toList();

    return response;
  }
}
