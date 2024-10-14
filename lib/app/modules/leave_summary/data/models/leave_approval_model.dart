import 'package:iroyal/app/modules/leave_summary/domain/entities/data_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/leave_approval_entity.dart';

class LeaveApprovalModel extends LeaveApprovalEntity {
  const LeaveApprovalModel({
    required super.fullName,
    required super.codeNo,
    required super.reason,
    required super.level,
    required super.status,
    required super.periode,
  });

  factory LeaveApprovalModel.fromJson(Map<String, dynamic> json) =>
      LeaveApprovalModel(
        fullName: json["full_name"],
        codeNo: json["code_no"],
        reason: json["reason"],
        level: json["level"],
        status: json["status"],
        periode: Periode.fromJson(json["periode"]),
      );

  Map<String, dynamic> toJson() => {
        "full_name": fullName,
        "code_no": codeNo,
        "reason": reason,
        "level": level,
        "status": status,
        "periode": periode.toJson(),
      };
}
