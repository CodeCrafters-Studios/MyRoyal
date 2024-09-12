import 'package:iroyal/app/modules/detail_tracking_document/domain/entities/detail_ptk_entities.dart';

class DetailPtkModel extends DetailPtkEntities {
  const DetailPtkModel({
    required super.title,
    required super.serialNumber,
    required super.fileAttachment,
    required super.companyName,
    required super.locationName,
    required super.deparmentName,
    required super.sectionName,
    required super.positionName,
    required super.reason,
    required super.laborQuantity,
    required super.employmentStatusesName,
    required super.jobDescription,
    required super.requirement,
    required super.reasonDescription,
    required super.createdAt,
    required super.state,
  });

  factory DetailPtkModel.empty() => const DetailPtkModel(
        title: '',
        serialNumber: '',
        fileAttachment: '',
        companyName: '',
        locationName: '',
        deparmentName: '',
        sectionName: '',
        positionName: '',
        reason: '',
        laborQuantity: '',
        employmentStatusesName: '',
        jobDescription: '',
        requirement: '',
        reasonDescription: '',
        createdAt: '',
        state: '',
      );

  factory DetailPtkModel.fromJson(Map<String, dynamic> json) => DetailPtkModel(
        title: json["title"],
        serialNumber: json["serial_number"],
        fileAttachment: json["file_attachment"],
        companyName: json["company_name"],
        locationName: json["location_name"],
        deparmentName: json["deparment_name"],
        sectionName: json["section_name"],
        positionName: json["position_name"],
        reason: json["reason"],
        laborQuantity: json["labor_quantity"],
        employmentStatusesName: json["employment_statuses_name"],
        jobDescription: json["job_description"],
        requirement: json["requirement"],
        reasonDescription: json["reason_description"],
        createdAt: json["created_at"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "serial_number": serialNumber,
        "file_attachment": fileAttachment,
        "company_name": companyName,
        "location_name": locationName,
        "deparment_name": deparmentName,
        "section_name": sectionName,
        "position_name": positionName,
        "reason": reason,
        "labor_quantity": laborQuantity,
        "employment_statuses_name": employmentStatusesName,
        "job_description": jobDescription,
        "requirement": requirement,
        "reason_description": reasonDescription,
        "created_at": createdAt,
        "state": state,
      };
}
