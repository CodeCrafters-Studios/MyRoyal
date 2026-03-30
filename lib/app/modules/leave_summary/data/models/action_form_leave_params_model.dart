import 'package:MyRoyal/app/modules/leave_summary/domain/entities/action_form_leave_params_entity.dart';

class ActionFormLeaveParamsModel extends ActionFormLeaveParamsEntity {
  const ActionFormLeaveParamsModel({
    required super.type,
    required super.codeNo,
    required super.level,
    required super.feedback,
    required super.typeSubmission,
  });

  factory ActionFormLeaveParamsModel.fromJson(Map<String, dynamic> json) =>
      ActionFormLeaveParamsModel(
        type: json["type"],
        level: json["level"],
        codeNo: json["code_no"],
        feedback: json["feedback"],
        typeSubmission: json["type_submission"],
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "code_no": codeNo,
        "level": level,
        "feedback": feedback,
        "type_submission": typeSubmission,
      };
}
