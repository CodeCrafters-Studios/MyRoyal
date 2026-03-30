import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_location_model.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class AttendanceRepository {
  Future<Either<Failure, AttendanceTodayModel>> getAttendanceToday();
  Future<Either<Failure, void>> recordAttendance(AttendanceRecordEntity entity);
  Future<Either<Failure, List<AttendanceLocationModel>>>
      getAttendanceLocation();
}
