import 'package:equatable/equatable.dart';

class LoginResponse extends Equatable {
  const LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.expiresin,
    required this.refreshToken,
    required this.createdAt,
  });

  final String accessToken;
  final String tokenType;
  final int expiresin;
  final String refreshToken;
  final int createdAt;

  @override
  List<Object?> get props => [
        accessToken,
        tokenType,
        expiresin,
        refreshToken,
        createdAt,
      ];
}
