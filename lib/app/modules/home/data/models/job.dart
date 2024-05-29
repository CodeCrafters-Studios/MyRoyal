import 'package:iroyal/app/modules/home/domain/entities/job.dart';

class JobModel extends Job {
  const JobModel({
    required super.company,
    required super.department,
    required super.section,
    required super.position,
    required super.joinDate,
    required super.absenceNumber,
    required super.workEmail,
    required super.employeeNumber,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) => JobModel(
        company: json['company'],
        department: json['department'],
        section: json['section'],
        position: json['position'],
        joinDate: json['join_date'],
        absenceNumber: json['absence_number'],
        workEmail: json['work_email'],
        employeeNumber: json['employee_number'],
      );

  Map<String, dynamic> toJson() => {
        'company': company,
        'department': department,
        'section': section,
        'position': position,
        'join_date': joinDate,
        'absence_number': absenceNumber,
        'work_email': workEmail,
        'employee_number': employeeNumber,
      };
}
