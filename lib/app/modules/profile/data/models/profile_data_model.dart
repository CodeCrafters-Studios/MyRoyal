import 'package:MyRoyal/app/modules/profile/data/models/documents_model.dart';
import 'package:MyRoyal/app/modules/profile/data/models/personal.dart';
import 'package:MyRoyal/app/modules/profile/data/models/professional.dart';
import 'package:MyRoyal/app/modules/profile/domain/entities/profile_data.dart';

class ProfileDataModel extends ProfileData {
  const ProfileDataModel({
    required super.personal,
    required super.professional,
    required super.documents,
  });

  factory ProfileDataModel.empty() => ProfileDataModel(
        personal: PersonalModel(),
        professional: const ProfessionalModel(),
        documents: const [],
      );

  factory ProfileDataModel.fromJson(Map<String, dynamic> json) =>
      ProfileDataModel(
        personal: PersonalModel.fromJson(json["personal"]),
        professional: ProfessionalModel.fromJson(json["professional"]),
        documents: List<DocumentsModel>.from(
            json["documents"].map((x) => DocumentsModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "personal": personal.toJson(),
        "professional": professional.toJson(),
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
      };
}
