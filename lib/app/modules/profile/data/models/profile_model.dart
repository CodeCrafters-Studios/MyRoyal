import 'package:MyRoyal/app/modules/profile/data/models/profile_data_model.dart';
import 'package:MyRoyal/app/modules/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.code,
    required super.message,
    required super.data,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        code: json["code"],
        message: json["message"],
        data: ProfileDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}
