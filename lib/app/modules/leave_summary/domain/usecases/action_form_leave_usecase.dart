import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/action_form_leave_params_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/action_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class ActionFormLeaveUsecase
    implements UseCase<ActionFormLeaveEntity, ActionFormLeaveParamsModel> {
  ActionFormLeaveUsecase(this.repository);

  final LeaveRepository repository;

  @override
  Future<Either<Failure, ActionFormLeaveEntity>> call(params) {
    return repository.actionFormLeave(params.toJson());
  }
}
