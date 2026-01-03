import 'package:iroyal/app/modules/home/data/models/user_data_model.dart';
import 'package:iroyal/app/modules/home/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.code,
    required super.message,
    required super.data,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        code: json["code"],
        message: json["message"],
        data: UserDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
