import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetPermitUsecase implements UseCaseNoParams {
  GetPermitUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getPermit();
  }
}
