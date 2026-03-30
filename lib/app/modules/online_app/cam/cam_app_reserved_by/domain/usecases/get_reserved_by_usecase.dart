import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_params_model.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/domain/repositories/reserved_by_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetReservedByUsecase
    implements UseCase<ReservedByModel, ReservedByParamsModel> {
  GetReservedByUsecase(this.repository);

  final ReservedByRepository repository;

  @override
  Future<Either<Failure, ReservedByModel>> call(ReservedByParamsModel params) {
    return repository.getReservedBy(params.toJson());
  }
}
