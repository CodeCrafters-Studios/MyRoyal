import 'package:MyRoyal/app/modules/detail_tracking_document/domain/entities/detail_ptk_entities.dart';

class DetailPtkModel extends DetailPtkEntities {
  const DetailPtkModel({
    required super.fileAttachment,
    required super.reason,
    required super.laborQuantity,
    required super.employmentStatusesName,
    required super.jobDescription,
    required super.requirement,
    required super.reasonDescription,
    required super.state,
  });

  factory DetailPtkModel.empty() => const DetailPtkModel(
        fileAttachment: '',
        reason: '',
        laborQuantity: '',
        employmentStatusesName: '',
        jobDescription: '',
        requirement: '',
        reasonDescription: '',
        state: '',
      );

  factory DetailPtkModel.fromJson(Map<String, dynamic> json) => DetailPtkModel(
        fileAttachment: json["file_attachment"],
        reason: json["reason"],
        laborQuantity: json["labor_quantity"],
        employmentStatusesName: json["employment_statuses_name"],
        jobDescription: json["job_description"],
        requirement: json["requirement"],
        reasonDescription: json["reason_description"],
        state: json["state"],
      );

  Map<String, dynamic> toJson() => {
        "file_attachment": fileAttachment,
        "reason": reason,
        "labor_quantity": laborQuantity,
        "employment_statuses_name": employmentStatusesName,
        "job_description": jobDescription,
        "requirement": requirement,
        "reason_description": reasonDescription,
        "state": state,
      };
}
