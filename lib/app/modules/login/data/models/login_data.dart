import 'package:iroyal/app/modules/login/domain/entities/login_data_response.dart';

class LoginData extends LoginDataResponse {
  const LoginData({required super.accessToken});

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        accessToken: json["access_token"],
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
      };
}
