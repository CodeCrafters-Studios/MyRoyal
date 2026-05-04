import 'package:MyRoyal/app/modules/webtel/domain/entities/webtel_data_entity.dart';

class WebtelDataModel extends WebtelDataEntity {
  const WebtelDataModel({
    required super.fullName,
    required super.departmentName,
    required super.lineNumber,
    required super.extentionNumber,
    required super.workEmail,
  });

  factory WebtelDataModel.fromJson(Map<String, dynamic> json) {
    String? processEmail(String? email) {
      if (email == null ||
          email.trim().isEmpty ||
          email == "tidak punya" ||
          email == "-" ||
          email == "#n/a") {
        return "-";
      }
      return email.trim();
    }

    int? processExtention(int? extNum) {
      if (extNum == null) {
        return 0;
      }
      return extNum;
    }

    return WebtelDataModel(
      fullName: json["full_name"]?.trim() ?? "",
      departmentName: json["department_name"]?.trim() ?? "",
      lineNumber: json["line_number"] as int?,
      extentionNumber: processExtention(json["extention_number"]),
      workEmail: processEmail(json["work_email"]),
    );
  }

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "department_name": departmentName,
        "line_number": lineNumber,
        "extention_number": extentionNumber,
        "work_email": workEmail,
      };
}
