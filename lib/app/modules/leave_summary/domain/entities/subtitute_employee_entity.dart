import 'package:equatable/equatable.dart';

class SubtituteEmployeeEntity extends Equatable {
  const SubtituteEmployeeEntity(
      {required this.employees, required this.yearlyLeave});

  final List<Employee> employees;
  final YearlyLeave yearlyLeave;

  @override
  List<Object> get props => [employees, yearlyLeave];
}

class Employee {
  final int employeeId;
  final String employeeNumber;
  final String fullName;

  Employee({
    required this.employeeId,
    required this.employeeNumber,
    required this.fullName,
  });

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        employeeId: json["employee_id"],
        employeeNumber: json["employee_number"],
        fullName: json["full_name"],
      );

  Map<String, dynamic> toJson() => {
        "employee_id": employeeId,
        "employee_number": employeeNumber,
        "full_name": fullName,
      };
}

class YearlyLeave {
  final DateTime? startdate;
  final DateTime? enddate;

  YearlyLeave({
    this.startdate,
    this.enddate,
  });

  factory YearlyLeave.fromJson(Map<String, dynamic> json) => YearlyLeave(
        startdate: json["startdate"] == null
            ? null
            : DateTime.parse(json["startdate"]),
        enddate:
            json["enddate"] == null ? null : DateTime.parse(json["enddate"]),
      );

  Map<String, dynamic> toJson() => {
        "startdate": startdate?.toIso8601String(),
        "enddate": enddate?.toIso8601String(),
      };
}
