import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_list_on_progress_entity.dart';

class TrackingDocumentListOnProgressModel
    extends TrackingDocumentListOnProgress {
  TrackingDocumentListOnProgressModel(
    super.createdAt,
    super.id,
    super.title,
    super.serialNumber,
    super.companyName,
    super.departmentName,
    super.sectionName,
    super.positionName,
    super.locationName,
    super.state,
    super.approvalId,
    super.isCompleted,
    super.targetCompletionDate,
    super.companyId,
    super.departmentId,
    super.locationId,
    super.stateTargetCompletionDate,
    super.lastApprovalBy,
  );

  factory TrackingDocumentListOnProgressModel.fromJson(
          Map<String, dynamic> json) =>
      TrackingDocumentListOnProgressModel(
        json["created_at"],
        json["id"],
        json["title"],
        json["serial_number"],
        json["company_name"],
        json["department_name"],
        json["section_name"],
        json["position_name"],
        json["location_name"],
        json["state"],
        json["approval_id"],
        json["is_completed"] ?? false,
        json["target_completion_date"],
        json["company_id"],
        json["department_id"],
        json["location_id"],
        json["state_target_completion_date"],
        json["last_approval_by"],
      );

  Map<String, dynamic> toJson() => {
        "created_at": createdAt,
        "id": id,
        "title": title,
        "serial_number": serialNumber,
        "company_name": companyName,
        "department_name": departmentName,
        "section_name": sectionName,
        "position_name": positionName,
        "location_name": locationName,
        "state": state,
        "approval_id": approvalId,
        "is_completed": isCompleted,
        "target_completion_date": targetCompletionDate,
        "company_id": companyId,
        "department_id": departmentId,
        "location_id": locationId,
        "state_target_completion_date": stateTargetCompletionDate,
        "last_approval_by": lastApprovalBy,
      };
}
