import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';
import 'package:iroyal/app/modules/home/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.username,
    required super.email,
    required super.employee,
    required super.job,
    required super.attendance,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        employee: EmployeeModel.fromJson(json["employee"]),
        job: JobModel.fromJson(json["job"]),
        attendance: AttendanceModel.fromJson(json["attendance"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "employee": employee.toJson(),
        "job": job.toJson(),
        "attendance": attendance.toJson(),
      };
}
