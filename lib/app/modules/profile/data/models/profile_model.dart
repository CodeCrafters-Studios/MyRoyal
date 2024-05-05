import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.fullName,
    required super.company,
    required super.department,
    required super.position,
    required super.reportTo,
    required super.remainingLeave,
    required super.birthdate,
    required super.email,
    required super.gender,
    required super.instagram,
    required super.linkedin,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        fullName: json["full_name"],
        company: json["company"],
        department: json["department"],
        position: json["position"],
        reportTo: json["report_to"],
        remainingLeave: json["remaining_leave"],
        birthdate: DateTime.parse(json["birthdate"]),
        email: json["email"],
        gender: json["gender"],
        instagram: json["instagram"],
        linkedin: json["linkedin"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "company": company,
        "department": department,
        "position": position,
        "report_to": reportTo,
        "remaining_leave": remainingLeave,
        "birthdate":
            "${birthdate.year.toString().padLeft(4, '0')}-${birthdate.month.toString().padLeft(2, '0')}-${birthdate.day.toString().padLeft(2, '0')}",
        "email": email,
        "gender": gender,
        "instagram": instagram,
        "linkedin": linkedin,
      };
}
