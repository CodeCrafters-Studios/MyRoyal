import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';

class LoginParamsModel extends LoginParams {
  const LoginParamsModel({
    super.username = '',
    super.password = '',
  });

  factory LoginParamsModel.fromLoginParams(LoginParams json) =>
      LoginParamsModel(
        username: json.username,
        password: json.password,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
      };
}
