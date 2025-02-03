import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/dashboard/domain/entities/detail_late_entity.dart';

class PermitDataEntity extends Equatable {
  final int id;
  final String employeeId;
  final String reason;
  final List<String> periodDate;
  final PeriodTime periodTime;
  final String code;
  final String codeNo;
  final String codeDefine;
  final bool canCancel;
  final String status;

  const PermitDataEntity({
    required this.id,
    required this.employeeId,
    required this.reason,
    required this.periodDate,
    required this.periodTime,
    required this.code,
    required this.codeNo,
    required this.codeDefine,
    required this.canCancel,
    required this.status,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        reason,
        periodDate,
        periodTime,
        code,
        codeNo,
        codeDefine,
        canCancel,
        status,
      ];
}
