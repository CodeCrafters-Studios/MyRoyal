import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';

class EditProfileResponseModel extends EditProfileResponse {
  const EditProfileResponseModel({
    required super.code,
    required super.message,
    required super.data,
  });

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
        code: json["code"],
        message: json["message"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
