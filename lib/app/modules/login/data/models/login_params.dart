import 'package:MyRoyal/app/modules/login/domain/entities/login_params.dart';

class LoginParamsModel extends LoginParams {
  const LoginParamsModel({
    super.grantType = '',
    super.clientId = '',
    super.clientSecret = '',
    super.username = '',
    super.password = '',
    super.scope = '',
    super.fcmToken = '',
    super.deviceId = '',
  });

  factory LoginParamsModel.fromLoginParams(LoginParams json) =>
      LoginParamsModel(
        grantType: json.grantType,
        clientId: json.clientId,
        clientSecret: json.clientSecret,
        username: json.username,
        password: json.password,
        scope: json.scope,
        fcmToken: json.fcmToken,
        deviceId: json.deviceId,
      );

  Map<String, dynamic> toJson() => {
        'grant_type': grantType,
        'client_id': clientId,
        'client_secret': clientSecret,
        'username': username,
        'password': password,
        'scope': scope,
        'fcm_token': fcmToken,
        'device_id': deviceId,
      };
}
