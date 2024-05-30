import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/home/data/models/attendance.dart';
import 'package:iroyal/app/modules/home/data/models/employee.dart';
import 'package:iroyal/app/modules/home/data/models/job.dart';

class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    required this.email,
    required this.children,
    required this.employee,
    required this.job,
    required this.attendance,
  });

  final int id;
  final String username;
  final String email;
  final bool children;
  final EmployeeModel employee;
  final JobModel job;
  final AttendanceModel attendance;

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        children,
        employee,
        job,
        attendance,
      ];
}
