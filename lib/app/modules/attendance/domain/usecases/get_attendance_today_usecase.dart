import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/attendance/data/models/attendance_today_model.dart';
import 'package:iroyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetAttendanceTodayUsecase
    implements UseCaseNoParams<AttendanceTodayModel> {
  GetAttendanceTodayUsecase({required this.repository});

  final AttendanceRepository repository;

  @override
  Future<Either<Failure, AttendanceTodayModel>> call() {
    return repository.getAttendanceToday();
  }
}
