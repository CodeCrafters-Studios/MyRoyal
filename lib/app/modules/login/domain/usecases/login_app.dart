import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';
import 'package:iroyal/app/modules/login/domain/repositories/login_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class LoginApp implements UseCase<LoginResponse, Map<String, dynamic>> {
  LoginApp(this.loginRepository);

  final LoginRepository loginRepository;
  @override
  Future<Either<Failure, LoginResponse>> call(Map<String, dynamic> params) {
    return loginRepository.loginApp(params);
  }
}
