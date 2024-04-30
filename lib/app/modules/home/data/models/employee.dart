import 'package:iroyal/app/modules/home/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.firstName,
    required super.lastName,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'first_name': firstName,
        'last_name': lastName,
      };
}
