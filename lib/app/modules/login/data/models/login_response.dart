import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    super.accessToken = '',
    super.tokenType = '',
    super.expiresin = 0,
    super.refreshToken = '',
    super.createdAt = 0,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        accessToken: json['access_token'] ?? '',
        tokenType: json['token_type'] ?? '',
        expiresin: json['expires_in'] ?? 0,
        refreshToken: json['refresh_token'] ?? '',
        createdAt: json['created_at'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        'access_token': accessToken,
        'token_type': tokenType,
        'expires_in': expiresin,
        'refresh_token': refreshToken,
        'created_at': createdAt,
      };
}
