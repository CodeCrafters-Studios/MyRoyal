import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';

class CacheUserLoginModel extends CacheUserLogin {
  const CacheUserLoginModel({
    required super.grantType,
    required super.username,
    required super.password,
    required super.clientId,
    required super.clientSecret,
  });

  factory CacheUserLoginModel.fromJson(Map<String, dynamic> json) =>
      CacheUserLoginModel(
        grantType: json['grant_type'],
        username: json['username'],
        password: json['password'],
        clientId: json['client_id'],
        clientSecret: json['client_secret'],
      );

  Map<String, dynamic> toJson() {
    return {
      'grant_type': grantType,
      'username': username,
      'password': password,
      'client_id': clientId,
      'client_secret': clientSecret,
    };
  }
}
