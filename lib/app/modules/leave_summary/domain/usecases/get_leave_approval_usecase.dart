import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetLeaveApprovalUsecase implements UseCaseNoParams {
  GetLeaveApprovalUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getLeaveApproval();
  }
}
