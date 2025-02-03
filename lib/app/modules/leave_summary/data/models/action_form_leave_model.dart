import 'package:iroyal/app/modules/leave_summary/domain/entities/action_form_leave_entity.dart';

class ActionFormLeaveModel extends ActionFormLeaveEntity {
  const ActionFormLeaveModel({required super.id, required super.codeNo});

  factory ActionFormLeaveModel.fromJson(Map<String, dynamic> json) =>
      ActionFormLeaveModel(
        id: json["id"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code_no": codeNo,
      };
}
