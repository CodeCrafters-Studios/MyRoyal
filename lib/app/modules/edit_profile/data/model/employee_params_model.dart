import 'package:iroyal/app/modules/edit_profile/domain/entities/employee_params.dart';

class EmployeeParamsModel extends EmployeeParams {
  const EmployeeParamsModel({
    required super.lastName,
    required super.npwp,
  });

  factory EmployeeParamsModel.fromJson(Map<String, dynamic> json) =>
      EmployeeParamsModel(
        lastName: json["last_name"],
        npwp: json["npwp"],
      );

  @override
  Map<String, dynamic> toJson() => {
        "last_name": lastName,
        "npwp": npwp,
      };
}
