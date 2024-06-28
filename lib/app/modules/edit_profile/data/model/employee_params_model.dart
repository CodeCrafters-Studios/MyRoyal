import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';

class EmployeeParamsModel extends EmployeeParams {
  const EmployeeParamsModel({
    required super.firstName,
    required super.lastName,
    required super.nickname,
    required super.npwp,
    required super.npwpStatus,
    required super.email,
    required super.instagram,
    required super.linkedIn,
    required super.maritalStatus,
  });

  factory EmployeeParamsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeParamsModel(
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickname: json["nickname"],
        npwp: json["npwp"],
        npwpStatus: json["npwp_status"],
        email: json["personal_email"],
        instagram: json["instagram"],
        linkedIn: json["linkedin"],
        maritalStatus: json["marital_status"],
      );

  Map<String, dynamic> toJson() => {
        "firs_name": firstName,
        "last_name": lastName,
        "nickname": nickname,
        "npwp": npwp,
        "npwp_status": npwpStatus,
        "personal_email": email,
        "instagram": instagram,
        "linkedin": linkedIn,
        "marital_status": maritalStatus,
      };
}
