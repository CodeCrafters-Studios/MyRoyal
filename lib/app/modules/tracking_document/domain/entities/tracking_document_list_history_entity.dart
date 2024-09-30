import 'package:equatable/equatable.dart';

class TrackingDocumentListHistoryEntity extends Equatable {
  const TrackingDocumentListHistoryEntity({
    required this.createdAt,
    required this.id,
    required this.title,
    required this.serialNumber,
    required this.companyName,
    required this.departmentName,
    required this.sectionName,
    required this.positionName,
    required this.locationName,
    required this.state,
    required this.approvalId,
    required this.isCompleted,
    required this.targetCompletionDate,
    required this.companyId,
    required this.departmentId,
    required this.locationId,
    required this.stateTargetCompletionDate,
    required this.needApproval,
    required this.lastApprovalBy,
  });

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
  final dynamic isCompleted;
  final int targetCompletionDate;
  final int companyId;
  final int departmentId;
  final int locationId;
  final String stateTargetCompletionDate;
  final bool needApproval;
  final String lastApprovalBy;

  @override
  List<Object?> get props => [
        createdAt,
        id,
        title,
        serialNumber,
        companyName,
        departmentName,
        sectionName,
        positionName,
        locationName,
        state,
        approvalId,
        isCompleted,
        targetCompletionDate,
        companyId,
        departmentId,
        locationId,
        locationId,
        stateTargetCompletionDate,
        needApproval,
        lastApprovalBy,
      ];
}
