import 'package:iroyal/app/modules/login/domain/entities/login_response.dart';

class LoginResponseModel extends LoginResponse {
  const LoginResponseModel();

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      const LoginResponseModel();

  Map<String, dynamic> toJson() => {};
}
