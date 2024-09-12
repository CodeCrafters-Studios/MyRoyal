import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_user_created_entities.dart';

class DetailUserCreatedModel extends DetailUserCreatedEntities {
  const DetailUserCreatedModel({
    required super.fullName,
    required super.positionName,
    required super.sectionName,
  });

  factory DetailUserCreatedModel.empty() => const DetailUserCreatedModel(
      fullName: '', positionName: '', sectionName: '');

  factory DetailUserCreatedModel.fromJson(Map<String, dynamic> json) =>
      DetailUserCreatedModel(
        fullName: json["full_name"],
        positionName: json["position_name"],
        sectionName: json["section_name"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "position_name": positionName,
        "section_name": sectionName,
      };
}
