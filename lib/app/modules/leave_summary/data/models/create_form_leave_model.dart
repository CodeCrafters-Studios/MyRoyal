import 'package:MyRoyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';

class CreateFormLeaveModel extends CreateFormLeaveEntity {
  const CreateFormLeaveModel({required super.id, required super.codeNo});

  factory CreateFormLeaveModel.fromJson(Map<String, dynamic> json) =>
      CreateFormLeaveModel(
        id: json["id"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code_no": codeNo,
      };
}
