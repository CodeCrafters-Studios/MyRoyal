import 'package:iroyal/app/modules/login/data/models/login_data.dart';
import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel({
    super.status = false,
    super.code = 0,
    super.message = '',
    super.data = const LoginData(accessToken: ''),
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      LoginResponseModel(
        status: json['status'] ?? false,
        code: json['code'] ?? 0,
        message: json['message'] ?? '',
        data: LoginData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
