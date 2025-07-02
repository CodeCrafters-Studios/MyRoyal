import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/update_reserved_by_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/update_reserved_by_params_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/domain/repositories/reserved_by_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class UpdateReservedByUsecase
    implements UseCase<UpdateReservedByModel, UpdateReservedByParamsModel> {
  UpdateReservedByUsecase(this.repository);

  final ReservedByRepository repository;

  @override
  Future<Either<Failure, UpdateReservedByModel>> call(
      UpdateReservedByParamsModel params) {
    return repository.updateReservedBy(params.toJson());
  }
}
