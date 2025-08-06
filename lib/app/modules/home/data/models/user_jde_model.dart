import 'package:iroyal/app/modules/home/domain/entities/user_jde_entity.dart';

class UserJdeModel extends UserJdeEntity {
  UserJdeModel(
      {required super.code, required super.message, required super.data});

  factory UserJdeModel.fromJson(Map<String, dynamic> json) => UserJdeModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  factory UserJdeModel.empty() => UserJdeModel(
        code: 0,
        message: '',
        data: Data(
          status: '',
          username: '',
          data: [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
