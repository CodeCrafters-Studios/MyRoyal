import 'package:equatable/equatable.dart';

class TokenResponse extends Equatable {
  const TokenResponse({
    required this.tokenType,
    required this.expiresIn,
    required this.accessToken,
    required this.refreshToken,
  });

  final String tokenType;
  final int expiresIn;
  final String accessToken;
  final String refreshToken;

  @override
  List<Object?> get props => [
        tokenType,
        expiresIn,
        accessToken,
        refreshToken,
      ];
}
