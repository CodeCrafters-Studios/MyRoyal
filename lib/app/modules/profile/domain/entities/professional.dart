import 'package:equatable/equatable.dart';

class Professional extends Equatable {
  const Professional({
    required this.company,
    required this.department,
    required this.position,
    required this.reportTo,
    required this.remainingLeave,
    required this.bpjsKesehatan,
    required this.bpjsTenagakerja,
    required this.active,
  });

  final String company;
  final String department;
  final String position;
  final String reportTo;
  final int remainingLeave;
  final String bpjsKesehatan;
  final String bpjsTenagakerja;
  final bool active;

  @override
  List<Object?> get props => [
        company,
        department,
        position,
        reportTo,
        remainingLeave,
        bpjsKesehatan,
        bpjsTenagakerja,
        active,
      ];
}
