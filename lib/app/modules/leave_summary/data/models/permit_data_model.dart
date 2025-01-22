import 'package:iroyal/app/modules/dashboard/domain/entities/detail_late_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/permit_data_entity.dart';

class PermitDataModel extends PermitDataEntity {
  const PermitDataModel({
    required super.id,
    required super.employeeId,
    required super.reason,
    required super.periodDate,
    required super.periodTime,
    required super.code,
    required super.codeNo,
    required super.codeDefine,
    required super.canCancel,
    required super.status,
  });

  factory PermitDataModel.fromJson(Map<String, dynamic> json) =>
      PermitDataModel(
        id: json["id"],
        employeeId: json["employee_id"],
        reason: json["reason"],
        periodDate: List<String>.from(json["period_date"].map((x) => x)),
        periodTime: PeriodTime.fromJson(json["period_time"]),
        code: json["code"],
        codeNo: json["code_no"],
        codeDefine: json["code_define"],
        canCancel: json["can_cancel"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "employee_id": employeeId,
        "reason": reason,
        "period_date": List<dynamic>.from(periodDate.map((x) => x)),
        "period_time": periodTime.toJson(),
        "code": code,
        "code_no": codeNo,
        "code_define": codeDefine,
        "can_cancel": canCancel,
        "status": status,
      };
}
