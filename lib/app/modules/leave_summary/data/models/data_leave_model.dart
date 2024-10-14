import 'package:iroyal/app/modules/leave_summary/domain/entities/data_leave_entity.dart';

class DataLeaveModel extends DataLeaveEntity {
  const DataLeaveModel({
    required super.codeNo,
    required super.reason,
    required super.status,
    required super.periode,
    required super.typeLeave,
    required super.canCancel,
  });

  factory DataLeaveModel.empty() => DataLeaveModel(
        codeNo: '',
        reason: '',
        status: '',
        periode: Periode(start: '', end: ''),
        typeLeave: '',
        canCancel: false,
      );

  factory DataLeaveModel.fromJson(Map<String, dynamic> json) => DataLeaveModel(
        codeNo: json["code_no"],
        reason: json["reason"],
        status: json["status"],
        periode: Periode.fromJson(json["periode"]),
        typeLeave: json["type_leave"],
        canCancel: json["can_cancel"],
      );

  Map<String, dynamic> toJson() => {
        "code_no": codeNo,
        "reason": reason,
        "status": status,
        "periode": periode.toJson(),
        "type_leave": typeLeave,
        "can_cancel": canCancel,
      };
}
