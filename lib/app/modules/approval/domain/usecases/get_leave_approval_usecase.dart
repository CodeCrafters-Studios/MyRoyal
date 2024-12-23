import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/approval/domain/repositories/approval_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetLeaveApprovalUsecase implements UseCaseNoParams {
  GetLeaveApprovalUsecase(this.repository);

  final ApprovalRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getLeaveApproval();
  }
}
