import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/approval/domain/repositories/approval_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetLeaveApprovalUsecase implements UseCaseNoParams {
  GetLeaveApprovalUsecase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getLeaveApproval();
  }
}
