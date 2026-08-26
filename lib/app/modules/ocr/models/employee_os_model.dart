import 'package:MyRoyal/app/modules/ocr/domain/entities/employee_os_entity.dart';

class EmployeeOsModel extends EmployeeOsEntity {
  EmployeeOsModel({
    required super.currentPage,
    required super.data,
    required super.totalPage,
  });

  factory EmployeeOsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeOsModel(
        currentPage: json["current_page"],
        data: List<EmployeeOsDataModel>.from(
            json["data"].map((x) => EmployeeOsDataModel.fromJson(x))),
        totalPage: json["total_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(
          data.map((x) => x.toJson()),
        ),
        "total_page": totalPage,
      };
}

class EmployeeOsDataModel extends EmployeeOsDataEntity {
  EmployeeOsDataModel({
    required super.id,
    required super.noRegistration,
    required super.idCard,
    required super.fullName,
    required super.status,
  });

  factory EmployeeOsDataModel.fromJson(Map<String, dynamic> json) =>
      EmployeeOsDataModel(
        id: json["id"],
        noRegistration: json["no_registration"],
        idCard: json["id_card"],
        fullName: json["full_name"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "no_registration": noRegistration,
        "id_card": idCard,
        "full_name": fullName,
        "status": status,
      };
}
