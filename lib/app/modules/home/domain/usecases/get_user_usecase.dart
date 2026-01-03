import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/data/models/user_model.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetUserUsecase implements UseCaseNoParams {
  GetUserUsecase(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, UserModel>> call() {
    return repository.getUser();
  }
}
