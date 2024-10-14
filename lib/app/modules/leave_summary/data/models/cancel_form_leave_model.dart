import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';

class CancelFormLeaveModel extends CancelFormLeaveEntity {
  const CancelFormLeaveModel({required super.id, required super.codeNo});

  factory CancelFormLeaveModel.fromJson(Map<String, dynamic> json) =>
      CancelFormLeaveModel(
        id: json["id"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code_no": codeNo,
      };
}
