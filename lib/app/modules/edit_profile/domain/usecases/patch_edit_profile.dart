class GetLoginParams implements UseCase<LoginParams, ParamsLogin> {
  GetLoginParams(this.loginRepository);

  final LoginRepository loginRepository;
  @override
  Future<Either<Failure, LoginParams>> call(ParamsLogin params) {
    return loginRepository.getLoginParam(
      grantType: params.grantType,
      username: params.username,
      password: params.password,
      clientId: params.clientId,
      clientSecret: params.clientSecret,
    );
  }
}

class ParamsLogin extends Equatable {
  const ParamsLogin({
    required this.grantType,
    required this.username,
    required this.password,
    required this.clientId,
    required this.clientSecret,
  });
  final String grantType;
  final String username;
  final String password;
  final String clientId;
  final String clientSecret;

  @override
  List<Object?> get props => [
        grantType,
        username,
        password,
        clientId,
        clientSecret,
      ];
}
