import 'package:equatable/equatable.dart';

class DetailProgressEntities extends Equatable {
  const DetailProgressEntities({
    required this.id,
    required this.approvalId,
    required this.userId,
    required this.state,
    required this.createdAt,
    required this.updatedAt,
    required this.feedback,
    required this.approvedAt,
    required this.softDeleted,
    required this.firstName,
    required this.lastName,
    required this.sectionName,
    required this.positionName,
    required this.forLabel,
  });

  final int id;
  final int approvalId;
  final int userId;
  final String state;
  final String createdAt;
  final DateTime updatedAt;
  final dynamic feedback;
  final dynamic approvedAt;
  final bool softDeleted;
  final String firstName;
  final String? lastName;
  final String sectionName;
  final String positionName;
  final String forLabel;

  @override
  List<Object?> get props => [
        id,
        approvalId,
        userId,
        state,
        createdAt,
        updatedAt,
        feedback,
        approvedAt,
        softDeleted,
        firstName,
        lastName,
        sectionName,
        positionName,
        forLabel,
      ];
}
