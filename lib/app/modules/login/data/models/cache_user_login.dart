import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';

class CacheUserLoginModel extends CacheUserLogin {
  const CacheUserLoginModel({
    required super.grantType,
    required super.clientId,
    required super.clientSecret,
    required super.username,
    required super.password,
    required super.scope,
  });

  factory CacheUserLoginModel.fromJson(Map<String, dynamic> json) =>
      CacheUserLoginModel(
        grantType: json['grant_type'],
        clientId: json['client_id'],
        clientSecret: json['client_secret'],
        username: json['username'],
        password: json['password'],
        scope: json['scope'],
      );

  Map<String, dynamic> toJson() {
    return {
      'grant_type': grantType,
      'client_id': clientId,
      'client_secret': clientSecret,
      'username': username,
      'password': password,
      'scope': scope,
    };
  }
}
