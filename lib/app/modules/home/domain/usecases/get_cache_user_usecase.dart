import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/user_data_model.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetCacheUserUsecase implements UseCaseNoParams {
  GetCacheUserUsecase(this.homeRepository);

  final HomeRepository homeRepository;

  @override
  Future<Either<Failure, UserDataModel>> call() {
    return homeRepository.getCacheUser();
  }
}
