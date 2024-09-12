import 'package:equatable/equatable.dart';

class DetailPtkEntities extends Equatable {
  final String title;
  final String serialNumber;
  final dynamic fileAttachment;
  final String companyName;
  final String locationName;
  final String deparmentName;
  final String sectionName;
  final String positionName;
  final String reason;
  final String laborQuantity;
  final String employmentStatusesName;
  final String jobDescription;
  final String requirement;
  final String reasonDescription;
  final String createdAt;
  final String state;

  const DetailPtkEntities({
    required this.title,
    required this.serialNumber,
    required this.fileAttachment,
    required this.companyName,
    required this.locationName,
    required this.deparmentName,
    required this.sectionName,
    required this.positionName,
    required this.reason,
    required this.laborQuantity,
    required this.employmentStatusesName,
    required this.jobDescription,
    required this.requirement,
    required this.reasonDescription,
    required this.createdAt,
    required this.state,
  });

  @override
  List<Object?> get props => [
        title,
        serialNumber,
        fileAttachment,
        companyName,
        locationName,
        deparmentName,
        sectionName,
        positionName,
        reason,
        laborQuantity,
        employmentStatusesName,
        jobDescription,
        requirement,
        reasonDescription,
        createdAt,
        state,
      ];
}
