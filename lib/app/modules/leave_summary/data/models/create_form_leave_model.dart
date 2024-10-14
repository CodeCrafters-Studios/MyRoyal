import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';

class CreateFormModel extends CreateFormLeaveEntity {
  const CreateFormModel({required super.id, required super.codeNo});

  factory CreateFormModel.fromJson(Map<String, dynamic> json) =>
      CreateFormModel(
        id: json["id"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code_no": codeNo,
      };
}
