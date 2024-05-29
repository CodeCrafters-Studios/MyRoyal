import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';

class LoginParamsModel extends LoginParams {
  const LoginParamsModel({
    super.grantType = '',
    super.username = '',
    super.password = '',
    super.clientId = '',
    super.clientSecret = '',
  });

  factory LoginParamsModel.fromLoginParams(LoginParams json) =>
      LoginParamsModel(
        grantType: json.grantType,
        username: json.username,
        password: json.password,
        clientId: json.clientId,
        clientSecret: json.clientSecret,
      );

  Map<String, dynamic> toJson() => {
        'grant_type': grantType,
        'username': username,
        'password': password,
        'client_id': clientId,
        'client_secret': clientSecret,
      };
}
