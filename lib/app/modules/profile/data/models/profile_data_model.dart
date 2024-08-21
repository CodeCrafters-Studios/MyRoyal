import 'package:iroyal/app/modules/profile/data/models/personal.dart';
import 'package:iroyal/app/modules/profile/data/models/professional.dart';
import 'package:iroyal/app/modules/profile/domain/entities/profile_data.dart';

class ProfileDataModel extends ProfileData {
  const ProfileDataModel(
      {required super.personal, required super.professional});

  factory ProfileDataModel.empty() => ProfileDataModel(
      personal: PersonalModel(), professional: const ProfessionalModel());

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      ProfileDataModel(
        personal: PersonalModel.fromJson(json["personal"]),
        professional: ProfessionalModel.fromJson(json["professional"]),
      );

  Map<String, dynamic> toJson() => {
        "personal": personal.toJson(),
        "professional": professional.toJson(),
      };
}
