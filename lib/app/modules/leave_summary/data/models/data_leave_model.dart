import 'package:MyRoyal/app/modules/leave_summary/domain/entities/data_leave_entity.dart';

class DataLeaveModel extends DataLeaveEntity {
  const DataLeaveModel({
    required super.codeNo,
    required super.reason,
    required super.revisionReject,
    required super.status,
    required super.periode,
    required super.typeLeave,
    required super.canCancel,
    required super.listPeriode,
  });

  factory DataLeaveModel.empty() => DataLeaveModel(
        codeNo: '',
        reason: '',
        revisionReject: '',
        status: '',
        periode: Periode(start: '', end: ''),
        typeLeave: '',
        canCancel: false,
        listPeriode: const [],
      );

  factory DataLeaveModel.fromJson(Map<String, dynamic> json) => DataLeaveModel(
        codeNo: json["code_no"],
        reason: json["reason"],
        revisionReject: json["revision_reject"] ?? '',
        status: json["status"],
        periode: Periode.fromJson(json["periode"]),
        typeLeave: json["type_leave"],
        canCancel: json["can_cancel"],
        listPeriode: List<String>.from(json["list_periode"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "code_no": codeNo,
        "reason": reason,
        "revision_reject": revisionReject,
        "status": status,
        "periode": periode.toJson(),
        "type_leave": typeLeave,
        "can_cancel": canCancel,
        "list_periode": List<dynamic>.from(listPeriode.map((x) => x)),
      };
}
