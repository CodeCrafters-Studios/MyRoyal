import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class CancelFormLeaveUsecase
    implements UseCase<CancelFormLeaveEntity, CancelFormLeaveParamsEntity> {
  CancelFormLeaveUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, CancelFormLeaveEntity>> call(params) {
    return repository.cancelFormLeave(params.toMap());
  }
}
