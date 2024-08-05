import 'package:iroyal/app/modules/login/domain/entities/cache_user_login.dart';

class CacheUserLoginModel extends CacheUserLogin {
  const CacheUserLoginModel({
    required super.username,
    required super.password,
  });

  factory CacheUserLoginModel.fromJson(Map<String, dynamic> json) =>
      CacheUserLoginModel(
        username: json['username'],
        password: json['password'],
      );

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
    };
  }
}
