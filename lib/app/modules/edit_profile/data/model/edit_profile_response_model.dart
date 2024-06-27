import 'package:iroyal/app/modules/edit_profile/domain/entities/edit_profile_response.dart';

class EditProfileResponseModel extends EditProfileResponse {
  const EditProfileResponseModel({
    required super.status,
    required super.message,
    required super.employee,
  });

  factory EditProfileResponseModel.fromJson(Map<String, dynamic> json) =>
      EditProfileResponseModel(
        status: json['status'] ?? '',
        message: json['message'] ?? '',
        employee: json['employee'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'message': message,
        'employee': employee,
      };
}
