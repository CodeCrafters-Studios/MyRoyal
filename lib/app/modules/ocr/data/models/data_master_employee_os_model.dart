import 'package:MyRoyal/app/modules/ocr/domain/entities/data_master_employee_os_entity.dart';

class DataMasterEmployeeOsModel extends DataMasterEmployeeOsEntity {
  DataMasterEmployeeOsModel({
    required super.religions,
    required super.maritalStatuses,
    required super.skills,
    required super.bloodTypes,
  });

  factory DataMasterEmployeeOsModel.fromJson(Map<String, dynamic> json) =>
      DataMasterEmployeeOsModel(
        religions: List<DatumModel>.from(
            json["religions"].map((x) => DatumModel.fromJson(x))),
        maritalStatuses: json["marital_statuses"] == null
            ? []
            : List<DatumModel>.from(
                json["marital_statuses"].map((x) => DatumModel.fromJson(x))),
        skills: List<DatumModel>.from(
            json["skills"].map((x) => DatumModel.fromJson(x))),
        bloodTypes: Map.from(json["blood_types"])
            .map((k, v) => MapEntry<String, String>(k, v)),
      );

  Map<String, dynamic> toJson() => {
        "religions": List<dynamic>.from(religions.map((x) => x.toJson())),
        "marital_statuses":
            List<dynamic>.from(maritalStatuses.map((x) => x.toJson())),
        "skills": List<dynamic>.from(skills.map((x) => x.toJson())),
        "blood_types":
            Map.from(bloodTypes).map((k, v) => MapEntry<String, dynamic>(k, v)),
      };
}

class DatumModel extends DatumEntity {
  DatumModel({required super.id, required super.name});

  factory DatumModel.fromJson(Map<String, dynamic> json) => DatumModel(
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
      };
}
