import 'package:iroyal/app/modules/home/domain/entities/employee.dart';

class EmployeeModel extends Employee {
  const EmployeeModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.birthdate,
    required super.gender,
    required super.maritalStatus,
    required super.availableLeave,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) => EmployeeModel(
        id: json['id'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        birthdate: json['birthdate'],
        gender: json['gender'],
        maritalStatus: json['marital_status'],
        availableLeave: json['available_leave'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        'first_name': firstName,
        'last_name': lastName,
        'birthdate': birthdate,
        'gender': gender,
        'marital_status': maritalStatus,
        'available_leave': availableLeave,
      };
}
