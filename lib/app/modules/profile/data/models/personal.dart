import 'package:iroyal/app/modules/profile/domain/entities/personal.dart';

class PersonalModel extends Personal {
  const PersonalModel({
    required super.fullName,
    required super.firstName,
    required super.lastName,
    required super.nickname,
    required super.birthdate,
    required super.birthplace,
    required super.gender,
    required super.maritalStatus,
    required super.npwp,
    required super.npwpStatus,
    required super.personalEmail,
    required super.instagram,
    required super.linkedin,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) => PersonalModel(
        fullName: json["full_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickname: json["nickname"],
        birthdate: DateTime.parse(json["birthdate"]),
        birthplace: json["birthplace"],
        gender: json["gender"],
        maritalStatus: json["marital_Status"],
        npwp: json["npwp"],
        npwpStatus: json["npwp_status"],
        personalEmail: json["personal_email"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "first_name": firstName,
        "last_name": lastName,
        "nickname": nickname,
        "birthdate":
            "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
        "birthplace": birthplace,
        "gender": gender,
        "marital_Status": maritalStatus,
        "npwp": npwp,
        "npwp_status": npwpStatus,
        "personal_email": personalEmail,
        "instagram": instagram,
        "linkedin": linkedin,
      };
}
