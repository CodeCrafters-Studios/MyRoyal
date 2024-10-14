import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetSubtituteEmployeeUsecase implements UseCaseNoParams {
  GetSubtituteEmployeeUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, SubtituteEmployeeEntity>> call() {
    return repository.getSubtituteEmployee();
  }
}
