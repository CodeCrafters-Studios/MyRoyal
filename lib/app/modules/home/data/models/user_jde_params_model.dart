import 'package:iroyal/app/modules/home/domain/entities/user_jde_params_entity.dart';

class UserJdeParamsModel extends UserJdeParamsEntity {
  UserJdeParamsModel({required super.username, required super.company});

  factory UserJdeParamsModel.fromJson(Map<String, dynamic> json) =>
      UserJdeParamsModel(
        username: json["username"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "company": company,
      };
}
