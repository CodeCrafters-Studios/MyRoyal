import 'package:iroyal/app/modules/profile/data/models/profile_data_model.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.status,
    required super.code,
    required super.message,
    required super.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: ProfileDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
