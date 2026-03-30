import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_model.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_jde_params_model.dart';
import 'package:MyRoyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetUserJdeUsecase implements UseCase<UserJdeModel, UserJdeParamsModel> {
  GetUserJdeUsecase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, UserJdeModel>> call(UserJdeParamsModel params) {
    return repository.getUserJDE(params.toJson());
  }
}
