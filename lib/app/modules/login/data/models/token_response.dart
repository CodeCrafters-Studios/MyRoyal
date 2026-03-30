import 'package:MyRoyal/app/modules/login/domain/entities/token_response.dart';

class TokenResponseModel extends TokenResponse {
  const TokenResponseModel({
    super.tokenType = '',
    super.expiresIn = 0,
    super.accessToken = '',
    super.refreshToken = '',
  });

  factory TokenResponseModel.fromJson(Map<String, dynamic> json) =>
      TokenResponseModel(
        tokenType: json["token_type"],
        expiresIn: json["expires_in"],
        accessToken: json["access_token"],
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
        "token_type": tokenType,
        "expires_in": expiresIn,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
