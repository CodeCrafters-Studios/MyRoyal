import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_permit_entity.dart';

class CreateFormPermitModel extends CreateFormPermitEntity {
  const CreateFormPermitModel({required super.id, required super.codeNo});

  factory CreateFormPermitModel.fromJson(Map<String, dynamic> json) =>
      CreateFormPermitModel(
        id: json["id"],
        codeNo: json["code_no"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code_no": codeNo,
      };
}
