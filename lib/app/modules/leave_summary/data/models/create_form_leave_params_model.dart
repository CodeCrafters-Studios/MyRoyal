import 'package:MyRoyal/app/modules/leave_summary/domain/entities/create_form_leave_params_entity.dart';

class CreateFormLeaveParamsModel extends CreateFormLeaveParamsEntity {
  const CreateFormLeaveParamsModel({
    required super.substituteId,
    required super.dateLeave,
    required super.reason,
  });

  factory CreateFormLeaveParamsModel.fromJson(Map<String, dynamic> json) =>
      CreateFormLeaveParamsModel(
        substituteId: json["substitute_id"],
        dateLeave: List<String>.from(json["date_leave"].map((x) => x)),
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "substitute_id": substituteId,
        "date_leave": List<dynamic>.from(dateLeave.map((x) => x)),
        "reason": reason,
      };
}
