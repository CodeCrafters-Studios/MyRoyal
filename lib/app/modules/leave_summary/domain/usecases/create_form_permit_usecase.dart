import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/models/create_form_permit_params_model.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/create_form_permit_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class CreateFormPermitUsecase
    implements UseCase<CreateFormPermitEntity, CreateFormPermitParamsModel> {
  final LeaveRepository repository;

  CreateFormPermitUsecase(this.repository);

  @override
  Future<Either<Failure, CreateFormPermitEntity>> call(params) {
    return repository.createFormPermit(params.toJson());
  }
}
