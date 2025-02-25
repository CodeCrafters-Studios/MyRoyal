import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/create_form_leave_params_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class CreateFormLeaveUsecase
    implements UseCase<CreateFormLeaveEntity, CreateFormLeaveParamsModel> {
  final LeaveRepository repository;

  CreateFormLeaveUsecase(this.repository);

  @override
  Future<Either<Failure, CreateFormLeaveEntity>> call(params) {
    return repository.createFormLeave(params.toJson());
  }
}
