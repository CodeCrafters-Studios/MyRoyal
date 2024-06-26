import 'package:iroyal/app/modules/profile/data/models/personal.dart';
import 'package:iroyal/app/modules/profile/data/models/professional.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({required super.personal, required super.professional});

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        personal: PersonalModel.fromJson(json["personal"]),
        professional: ProfessionalModel.fromJson(json["work"]),
      );

  Map<String, dynamic> toJson() => {
        "personal": personal,
        "work": professional,
      };
}
