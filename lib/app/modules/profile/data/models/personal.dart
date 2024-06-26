import 'package:iroyal/app/modules/profile/domain/entities/personal.dart';

class PersonalModel extends Personal {
  const PersonalModel({
    required super.id,
    required super.fullName,
    required super.lastName,
    required super.birthdate,
    required super.gender,
    required super.maritalStatus,
    required super.nickname,
    required super.idCard,
    required super.birthplace,
    required super.instagram,
    required super.linkedin,
    required super.npwp,
    required super.npwpStatus,
    required super.smoker,
    required super.personalEmail,
  });

  factory PersonalModel.fromJson(Map<String, dynamic> json) => PersonalModel(
        id: json["id"],
        fullName: json["full_name"],
        lastName: json["last_name"],
        birthdate: DateTime.parse(json["birthdate"]),
        gender: json["gender"],
        maritalStatus: json["marital_status"],
        nickname: json["nickname"],
        idCard: json["id_card"],
        birthplace: json["birthplace"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
        npwp: json["npwp"],
        npwpStatus: json["npwp_status"],
        smoker: json["smoker"],
        personalEmail: json["personal_email"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "last_name": lastName,
        "birthdate":
            "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
        "gender": gender,
        "marital_status": maritalStatus,
        "nickname": nickname,
        "id_card": idCard,
        "birthplace": birthplace,
        "instagram": instagram,
        "linkedin": linkedin,
        "npwp": npwp,
        "npwp_status": npwpStatus,
        "smoker": smoker,
        "personal_email": personalEmail,
      };
}
