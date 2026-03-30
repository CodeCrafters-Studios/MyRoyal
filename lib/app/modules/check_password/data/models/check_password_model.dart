import 'package:MyRoyal/app/modules/check_password/domain/entities/check_password_entity.dart';

class CheckPasswordModel extends CheckPasswordEntity {
  const CheckPasswordModel(
      {required super.code, required super.message, required super.data});

  factory CheckPasswordModel.fromJson(Map<String, dynamic> json) =>
      CheckPasswordModel(
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data,
      };
}

class CheckPasswordParams {
  final String password;

  CheckPasswordParams({
    required this.password,
  });

  factory CheckPasswordParams.fromJson(Map<String, dynamic> json) =>
      CheckPasswordParams(
        password: json["password"],
      );

  Map<String, dynamic> toJson() => {
        "password": password,
      };
}
