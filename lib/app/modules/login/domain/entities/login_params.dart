import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  const LoginParams({
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
  List<Object?> get props => [
        grantType,
        clientId,
        clientSecret,
        username,
        password,
        scope,
      ];
}
