import 'package:equatable/equatable.dart';

class MyTeamsJob extends Equatable {
  const MyTeamsJob({
    required this.company,
    required this.department,
    required this.section,
    required this.position,
    required this.joinDate,
    required this.absenceNumber,
    required this.workEmail,
    required this.employeeNumber,
  });

  final String company;
  final String department;
  final String section;
  final String position;
  final String joinDate;
  final String absenceNumber;
  final String workEmail;
  final String employeeNumber;

  @override
  List<Object?> get props => [
        company,
        department,
        section,
        position,
        joinDate,
        absenceNumber,
        workEmail,
        employeeNumber,
      ];
}
