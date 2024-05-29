import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/tracking_document/data/models/company_model.dart';
import 'package:iroyal/app/modules/tracking_document/data/models/content_model.dart';

class TrackingDocument extends Equatable {
  const TrackingDocument({
    required this.id,
    required this.content,
    required this.additionalCriteria,
    required this.reason,
    required this.reasonDescription,
    required this.status,
    required this.approvedBy,
    required this.complete,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.aasmState,
    required this.submissionId,
    required this.serialNumber,
    required this.title,
    required this.priority,
    required this.recipientId,
    required this.isCompleted,
    required this.laborQuantity,
    required this.replacedEmployeeId,
    required this.company,
    required this.department,
    required this.location,
    required this.position,
    required this.employmentStatus,
    required this.section,
  });

  final int id;
  final ContentModel content;
  final String additionalCriteria;
  final String reason;
  final ContentModel reasonDescription;
  final String status;
  final String approvedBy;
  final String complete;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int userId;
  final String aasmState;
  final int submissionId;
  final String serialNumber;
  final String title;
  final String priority;
  final int recipientId;
  final String isCompleted;
  final int laborQuantity;
  final dynamic replacedEmployeeId;
  final CompanyModel company;
  final CompanyModel department;
  final CompanyModel location;
  final CompanyModel position;
  final CompanyModel employmentStatus;
  final CompanyModel section;

  @override
  List<Object?> get props => [
        id,
        content,
        additionalCriteria,
        reason,
        reasonDescription,
        status,
        approvedBy,
        complete,
        createdAt,
        updatedAt,
        userId,
        aasmState,
        submissionId,
        serialNumber,
        title,
        priority,
        recipientId,
        isCompleted,
        laborQuantity,
        replacedEmployeeId,
        company,
        department,
        location,
        position,
        employmentStatus,
        section,
      ];
}
