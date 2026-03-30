import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/attendance/domain/repositories/attendance_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetAttendanceLocationUsecase implements UseCaseNoParams {
  GetAttendanceLocationUsecase({required this.repository});

  final AttendanceRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getAttendanceLocation();
  }
}
