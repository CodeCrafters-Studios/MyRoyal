import 'package:equatable/equatable.dart';

class LoginParams extends Equatable {
  const LoginParams({
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
