import 'package:equatable/equatable.dart';

class Professional extends Equatable {
  const Professional({
    required this.idCard,
    required this.employeeNumber,
    required this.reaminingLeave,
    required this.bpjsKesehatan,
    required this.bpjsKetenagakerjaan,
    required this.workEmail,
    required this.position,
    required this.department,
    required this.joinDate,
    required this.reportTo,
  });

  final String idCard;
  final String employeeNumber;
  final String reaminingLeave;
  final String bpjsKesehatan;
  final String bpjsKetenagakerjaan;
  final String workEmail;
  final String position;
  final String department;
  final String joinDate;
  final String reportTo;

  @override
  List<Object?> get props => [
        idCard,
        employeeNumber,
        reaminingLeave,
        bpjsKesehatan,
        bpjsKetenagakerjaan,
        workEmail,
        position,
        department,
        joinDate,
        reportTo,
      ];
}
