import 'package:iroyal/app/modules/login/data/models/login_data.dart';
import 'package:iroyal/app/modules/login/data/models/token_response.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    super.code = 0,
    super.message = '',
    super.data = const LoginData(token: TokenResponseModel()),
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        code: json['code'] ?? 0,
        message: json['message'] ?? '',
        data: LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
