import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/attendance/domain/entities/attendance_record_entity.dart';
import 'package:MyRoyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class RecordAttendanceUsecase {
  RecordAttendanceUsecase({required this.repository});

  final AttendanceRepository repository;

  Future<Either<Failure, void>> call(
    AttendanceRecordEntity entity,
  ) {
    return repository.recordAttendance(entity);
  }
}
