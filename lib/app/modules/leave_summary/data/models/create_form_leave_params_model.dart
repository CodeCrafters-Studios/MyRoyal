import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_params_entity.dart';

class CreateFormParamsModel extends CreateFormLeaveParamsEntity {
  const CreateFormParamsModel({
    required super.substituteId,
    required super.dateLeave,
    required super.reason,
  });

  factory CreateFormParamsModel.fromJson(Map<String, dynamic> json) =>
      CreateFormParamsModel(
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
