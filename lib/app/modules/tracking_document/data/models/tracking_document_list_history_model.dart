import 'package:iroyal/app/modules/tracking_document/domain/entities/tracking_document_list_history_entity.dart';

class TrackingDocumentListHistoryModel
    extends TrackingDocumentListHistoryEntity {
  const TrackingDocumentListHistoryModel({
    required super.createdAt,
    required super.id,
    required super.title,
    required super.serialNumber,
    required super.companyName,
    required super.departmentName,
    required super.sectionName,
    required super.positionName,
    required super.locationName,
    required super.state,
    required super.approvalId,
    required super.isCompleted,
    required super.targetCompletionDate,
    required super.companyId,
    required super.departmentId,
    required super.locationId,
    required super.stateTargetCompletionDate,
    required super.lastApprovalBy,
  });

  factory TrackingDocumentListHistoryModel.empty() {
    return const TrackingDocumentListHistoryModel(
      createdAt: '',
      id: 0,
      title: '',
      serialNumber: '',
      companyName: '',
      departmentName: '',
      sectionName: '',
      positionName: '',
      locationName: '',
      state: '',
      approvalId: 0,
      isCompleted: '',
      targetCompletionDate: 0,
      companyId: 0,
      departmentId: 0,
      locationId: 0,
      stateTargetCompletionDate: '',
      lastApprovalBy: '',
    );
  }

  factory TrackingDocumentListHistoryModel.fromJson(
          Map<String, dynamic> json) =>
      TrackingDocumentListHistoryModel(
        createdAt: json["created_at"],
        id: json["id"],
        title: json["title"],
        serialNumber: json["serial_number"],
        companyName: json["company_name"],
        departmentName: json["department_name"],
        sectionName: json["section_name"],
        positionName: json["position_name"],
        locationName: json["location_name"],
        state: json["state"],
        approvalId: json["approval_id"],
        isCompleted: json["is_completed"],
        targetCompletionDate: json["target_completion_date"],
        companyId: json["company_id"],
        departmentId: json["department_id"],
        locationId: json["location_id"],
        stateTargetCompletionDate: json["state_target_completion_date"],
        lastApprovalBy: json["last_approval_by"],
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
