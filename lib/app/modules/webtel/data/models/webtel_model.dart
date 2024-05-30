import 'package:iroyal/app/modules/webtel/domain/entities/webtel.dart';

class WebtelModel extends Webtel {
  const WebtelModel({
    required super.fullname,
    required super.departmentName,
    required super.ext,
    required super.branchName,
    required super.id,
  });

  factory WebtelModel.fromJson(Map<String, dynamic> json) => WebtelModel(
        fullname: json["full_name"],
        departmentName: json["department_name"],
        ext: json["ext"],
        branchName: json["branch_name"],
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullname,
        "department_name": departmentName,
        "ext": ext,
        "branch_name": branchName,
        "id": id,
      };
}
