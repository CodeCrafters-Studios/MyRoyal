import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetUser implements UseCaseNoParams {
  GetUser(this.repository);

  final HomeRepository repository;

  @override
  Future<Either<Failure, User>> call() {
    return repository.getUser();
  }
}
