import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';
import 'package:iroyal/app/modules/home/domain/repositories/home_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetCacheUser implements UseCase<User, NoParams> {
  GetCacheUser(this.homeRepository);

  final HomeRepository homeRepository;

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return homeRepository.getCacheUser();
  }
}
