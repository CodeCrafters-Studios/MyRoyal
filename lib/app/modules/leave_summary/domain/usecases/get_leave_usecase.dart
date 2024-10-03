import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetLeaveUsecase implements UseCaseNoParams {
  GetLeaveUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() async {
    return await repository.getLeave();
  }
}
