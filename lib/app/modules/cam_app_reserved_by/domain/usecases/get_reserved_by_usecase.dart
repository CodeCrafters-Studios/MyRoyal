import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/data/models/reserved_by_params_model.dart';
import 'package:iroyal/app/modules/cam_app_reserved_by/domain/repositories/reserved_by_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetReservedByUsecase
    implements UseCase<ReservedByModel, ReservedByParamsModel> {
  GetReservedByUsecase(this.repository);

  final ReservedByRepository repository;

  @override
  Future<Either<Failure, ReservedByModel>> call(ReservedByParamsModel params) {
    return repository.getReservedBy(params.toJson());
  }
}
