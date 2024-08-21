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
      grantType: params.grantType,
      clientId: params.clientId,
      clientSecret: params.clientSecret,
      username: params.username,
      password: params.password,
      scope: params.scope,
    );
  }
}

class ParamsLogin extends Equatable {
  const ParamsLogin({
    required this.grantType,
    required this.clientId,
    required this.clientSecret,
    required this.username,
    required this.password,
    required this.scope,
  });

  final String grantType;
  final String clientId;
  final String clientSecret;
  final String username;
  final String password;
  final String scope;

  @override
  List<Object?> get props =>
      [grantType, clientId, clientSecret, username, password, scope];
}
