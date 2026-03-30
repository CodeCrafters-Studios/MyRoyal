import 'package:MyRoyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';

class SubtituteEmployeeModel extends SubtituteEmployeeEntity {
  const SubtituteEmployeeModel(
      {required super.employees, required super.yearlyLeave});

  factory SubtituteEmployeeModel.fromJson(Map<String, dynamic> json) =>
      SubtituteEmployeeModel(
        employees: json["employees"] == null
            ? []
            : List<Employee>.from(
                json["employees"]!.map((x) => Employee.fromJson(x))),
        yearlyLeave: YearlyLeave.fromJson(json["yearlyLeave"]),
      );

  Map<String, dynamic> toJson() => {
        "employees": List<dynamic>.from(employees.map((x) => x.toJson())),
        "yearlyLeave": yearlyLeave.toJson(),
      };
}
