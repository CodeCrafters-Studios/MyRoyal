class TrackingDocumentListOnProgress {
  TrackingDocumentListOnProgress(
    this.createdAt,
    this.id,
    this.title,
    this.serialNumber,
    this.companyName,
    this.departmentName,
    this.sectionName,
    this.positionName,
    this.locationName,
    this.state,
    this.approvalId,
    this.isCompleted,
    this.targetCompletionDate,
    this.companyId,
    this.departmentId,
    this.locationId,
    this.stateTargetCompletionDate,
    this.lastApprovalBy,
  );

  final String createdAt;
  final int id;
  final String title;
  final String serialNumber;
  final String companyName;
  final String departmentName;
  final String sectionName;
  final String positionName;
  final String locationName;
  final String state;
  final int approvalId;
  final bool? isCompleted;
  final int targetCompletionDate;
  final int companyId;
  final int departmentId;
  final int locationId;
  final String stateTargetCompletionDate;
  final String lastApprovalBy;
}
