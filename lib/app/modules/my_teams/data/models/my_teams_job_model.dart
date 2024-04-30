import 'package:iroyal/app/modules/my_teams/domain/entities/my_teams_job.dart';

class MyTeamsJobModel extends MyTeamsJob {
  const MyTeamsJobModel({
    required super.company,
    required super.department,
    required super.section,
    required super.position,
    required super.joinDate,
    required super.absenceNumber,
    required super.workEmail,
    required super.employeeNumber,
  });

  factory MyTeamsJobModel.fromJson(Map<String, dynamic> json) =>
      MyTeamsJobModel(
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
