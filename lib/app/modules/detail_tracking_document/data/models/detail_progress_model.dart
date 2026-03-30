import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/detail_progress_entities.dart';

class DetailProgressModel extends DetailProgressEntities {
  const DetailProgressModel({
    required super.fullName,
    required super.positionName,
    required super.sectionName,
    required super.state,
    required super.createdAt,
    required super.approvedAt,
    required super.forLabel,
  });

  factory DetailProgressModel.empty() => const DetailProgressModel(
        fullName: '',
        positionName: '',
        sectionName: '',
        state: '',
        createdAt: '',
        approvedAt: '',
        forLabel: '',
      );

  factory DetailProgressModel.fromJson(Map<String, dynamic> json) =>
      DetailProgressModel(
        fullName: json["full_name"],
        positionName: json["position_name"],
        sectionName: json["section_name"],
        state: json["state"],
        createdAt: json["created_at"],
        approvedAt: json["approved_at"],
        forLabel: json["for_label"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "position_name": positionName,
        "section_name": sectionName,
        "state": state,
        "created_at": createdAt,
        "approved_at": approvedAt,
        "for_label": forLabel,
      };
}
