import 'package:iroyal/app/modules/login/domain/entities/login_params.dart';

class LoginParamsModel extends LoginParams {
  const LoginParamsModel({
    super.grantType = '',
    super.clientId = '',
    super.clientSecret = '',
    super.username = '',
    super.password = '',
    super.scope = '',
  });

  factory LoginParamsModel.fromLoginParams(LoginParams json) =>
      LoginParamsModel(
        grantType: json.grantType,
        clientId: json.clientId,
        clientSecret: json.clientSecret,
        username: json.username,
        password: json.password,
        scope: json.scope,
      );

  Map<String, dynamic> toJson() => {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'password': password,
        'scope': scope,
      };
}
