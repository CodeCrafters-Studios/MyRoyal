import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';

class WebtelModel extends Webtel {
  const WebtelModel({
    required super.fullname,
    required super.departmentName,
    required super.lineNumber,
    required super.extentionNumber,
    required super.branchName,
    required super.workEmail,
  });

  factory WebtelModel.fromJson(Map<String, dynamic> json) => WebtelModel(
        fullname: json["full_name"],
        departmentName: json["department_name"],
        lineNumber: json["line_number"],
        extentionNumber: json["extention_number"],
        branchName: json["branch_name"],
        workEmail: json["work_email"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullname,
        "department_name": departmentName,
        "line_number": departmentName,
        "extention_number": extentionNumber,
        "branch_name": branchName,
        "workEmail": workEmail,
      };
}
