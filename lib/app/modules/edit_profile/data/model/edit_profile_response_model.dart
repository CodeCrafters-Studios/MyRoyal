import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';

class EditProfileResponseModel extends EditProfileResponse {
  const EditProfileResponseModel({
    required super.status,
    required super.code,
    required super.message,
    required super.data,
  });

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
        status: json["status"],
        code: json["code"],
        message: json["message"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "code": code,
        "message": message,
        "data": data,
      };
}
