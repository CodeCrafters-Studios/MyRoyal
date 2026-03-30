import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:MyRoyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetAttendanceTodayUsecase
    implements UseCaseNoParams<AttendanceTodayModel> {
  GetAttendanceTodayUsecase({required this.repository});

  final AttendanceRepository repository;

  @override
  Future<Either<Failure, AttendanceTodayModel>> call() {
    return repository.getAttendanceToday();
  }
}
