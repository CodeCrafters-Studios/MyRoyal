import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/data_leave_entity.dart';

class ApprovalEntity extends Equatable {
  const ApprovalEntity({
    required this.fullName,
    required this.codeNo,
    required this.reason,
    required this.level,
    required this.status,
    required this.periode,
    required this.listPeriode,
  });

  final String fullName;
  final String codeNo;
  final String reason;
  final int level;
  final String status;
  final Periode periode;
  final List<String> listPeriode;

  @override
  List<Object?> get props => [
        fullName,
        codeNo,
        reason,
        level,
        status,
        periode,
        listPeriode,
      ];
}
