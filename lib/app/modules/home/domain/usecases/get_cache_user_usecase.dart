import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/home/data/models/user_data_model.dart';
import 'package:MyRoyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetCacheUserUsecase implements UseCaseNoParams {
  GetCacheUserUsecase(this.homeRepository);

  final HomeRepository homeRepository;

  @override
  Future<Either<Failure, UserDataModel>> call() {
    return homeRepository.getCacheUser();
  }
}
