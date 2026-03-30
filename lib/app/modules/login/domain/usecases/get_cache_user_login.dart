import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/login/domain/entities/cache_user_login.dart';
import 'package:MyRoyal/app/modules/login/domain/repositories/login_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetCacheUserLogin implements UseCase<CacheUserLogin, NoParams> {
  GetCacheUserLogin(this.loginRepository);

  final LoginRepository loginRepository;
  @override
  Future<Either<Failure, CacheUserLogin>> call(NoParams params) {
    return loginRepository.getCacheUserLogin();
  }
}
