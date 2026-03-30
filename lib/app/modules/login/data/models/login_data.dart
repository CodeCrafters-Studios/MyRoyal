import 'package:MyRoyal/app/modules/login/data/models/token_response.dart';
import 'package:MyRoyal/app/modules/login/domain/entities/login_data.dart';

class LoginData extends LoginDataResponse {
  const LoginData({required super.token});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        token: TokenResponseModel.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token.toJson(),
      };
}
