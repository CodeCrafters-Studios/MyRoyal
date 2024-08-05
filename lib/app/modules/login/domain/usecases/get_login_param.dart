import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';
import 'package:iroyal/app/modules/login/domain/repositories/login_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetLoginParams implements UseCase<LoginParams, ParamsLogin> {
  GetLoginParams(this.loginRepository);

  final LoginRepository loginRepository;
  @override
  Future<Either<Failure, LoginParams>> call(ParamsLogin params) {
    return loginRepository.getLoginParam(
        username: params.username, password: params.password);
  }
}

class ParamsLogin extends Equatable {
  const ParamsLogin({
    required this.username,
    required this.password,
  });
  final String username;
  final String password;

  @override
  List<Object?> get props => [username, password];
}
