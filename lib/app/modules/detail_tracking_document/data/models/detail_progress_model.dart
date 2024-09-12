import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_progress_entities.dart';

class DetailProgressModel extends DetailProgressEntities {
  const DetailProgressModel({
    required super.id,
    required super.approvalId,
    required super.userId,
    required super.state,
    required super.createdAt,
    required super.updatedAt,
    required super.feedback,
    required super.approvedAt,
    required super.softDeleted,
    required super.firstName,
    required super.lastName,
    required super.sectionName,
    required super.positionName,
    required super.forLabel,
  });

  factory DetailProgressModel.empty() => DetailProgressModel(
        id: 0,
        approvalId: 0,
        userId: 0,
        state: 'state',
        createdAt: '',
        updatedAt: DateTime(0),
        feedback: 'feedback',
        approvedAt: 'approvedAt',
        softDeleted: false,
        firstName: 'firstName',
        lastName: '',
        sectionName: '',
        positionName: '',
        forLabel: '',
      );

  factory DetailProgressModel.fromJson(Map<String, dynamic> json) =>
      DetailProgressModel(
        id: json["id"],
        approvalId: json["approval_id"],
        userId: json["user_id"],
        state: json["state"],
        createdAt: json["created_at"],
        updatedAt: DateTime.parse(json["updated_at"]),
        feedback: json["feedback"],
        approvedAt: json["approved_at"],
        softDeleted: json["soft_deleted"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        sectionName: json["section_name"],
        positionName: json["position_name"],
        forLabel: json["for_label"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "approval_id": approvalId,
        "user_id": userId,
        "state": state,
        "created_at": createdAt,
        "updated_at": updatedAt.toIso8601String(),
        "feedback": feedback,
        "approved_at": approvedAt,
        "soft_deleted": softDeleted,
        "first_name": firstName,
        "last_name": lastName,
        "section_name": sectionName,
        "position_name": positionName,
        "for_label": forLabel,
      };
}
