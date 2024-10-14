import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_params_entity.dart';

class CancelFormLeaveParamsModel extends CancelFormLeaveParamsEntity {
  const CancelFormLeaveParamsModel({
    required super.type,
    required super.codeNo,
    required super.level,
  });

  factory CancelFormLeaveParamsModel.fromJson(Map<String, dynamic> json) =>
      CancelFormLeaveParamsModel(
        type: json["type"],
        level: json["level"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code_no": codeNo,
        "level": level,
      };
}
