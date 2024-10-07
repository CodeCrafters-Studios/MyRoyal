import 'package:iroyal/app/modules/profile/domain/entities/personal.dart';

class PersonalModel extends Personal {
  PersonalModel({
    super.fullName = '',
    super.firstName = '',
    super.lastName = '',
    super.nickname = '',
    DateTime? birthdate,
    super.birthplace = '',
    super.gender = '',
    super.maritalStatus = '',
    super.npwp = '',
    super.npwpStatus = '',
    super.personalEmail = '',
    super.instagram = '',
    super.linkedin = '',
    super.profilePicture = '',
  }) : super(birthdate: birthdate ?? DateTime(0));

  factory PersonalModel.fromJson(Map<String, dynamic> json) => PersonalModel(
        fullName: json["full_name"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        nickname: json["nickname"],
        birthdate: json["birthdate"] != null
            ? DateTime.parse(json["birthdate"])
            : DateTime(0),
        birthplace: json["birthplace"],
        gender: json["gender"],
        maritalStatus: json["marital_Status"],
        npwp: json["npwp"],
        npwpStatus: json["npwp_status"],
        personalEmail: json["personal_email"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        profilePicture: json["profile_picture"],
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
        "profile_picture": profilePicture,
      };
}
