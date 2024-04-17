import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/repositories/login_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class AuthBiometricsLogin implements UseCase<bool, NoParams> {
  AuthBiometricsLogin(this.loginRepository);

  final LoginRepository loginRepository;
  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return loginRepository.authBiometrics();
  }
}
