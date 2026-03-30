import 'package:MyRoyal/app/modules/edit_profile/domain/entities/employee_params.dart';

class EmployeeParamsModel extends EmployeeParams {
  const EmployeeParamsModel({
    required super.employeeId,
    required super.firstName,
    required super.lastName,
    required super.nickname,
    required super.email,
    required super.instagram,
    required super.linkedIn,
    required super.maritalStatus,
    required super.birthPlace,
    required super.birthDate,
    required super.gender,
    required super.profilePicture,
  });

  factory EmployeeParamsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeParamsModel(
        employeeId: json["employee_id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickname: json["nickname"],
        email: json["personal_email"],
        instagram: json["instagram"],
        linkedIn: json["linkedin"],
        maritalStatus: json["marital_status"],
        birthPlace: json["birthplace"],
        birthDate: json["date_of_birth"],
        gender: json["gender"],
        profilePicture: json["profile_picture"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "first_name": firstName,
        "last_name": lastName,
        "nickname": nickname,
        "personal_email": email,
        "instagram": instagram,
        "linkedin": linkedIn,
        "marital_status": maritalStatus,
        "birthplace": birthPlace,
        "date_of_birth": birthDate,
        "gender": gender,
        "profile_picture": profilePicture,
      };
}
