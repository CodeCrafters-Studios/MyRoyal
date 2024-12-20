import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_permit_params_entity.dart';

class CreateFormPermitParamsModel extends CreateFormPermitParamsEntity {
  const CreateFormPermitParamsModel({
    required super.typeCode,
    required super.startDate,
    required super.endDate,
    required super.startTime,
    required super.endTime,
    required super.reason,
  });

  factory CreateFormPermitParamsModel.fromJson(Map<String, dynamic> json) =>
      CreateFormPermitParamsModel(
        typeCode: json["type"],
        startDate: json["startdate"],
        endDate: json["enddate"],
        startTime: json["starttime"],
        endTime: json["endtime"],
        reason: json["reason"],
      );

  Map<String, dynamic> toJson() => {
        "type": typeCode,
        "startdate": startDate,
        "enddate": endDate,
        "starttime": startTime,
        "endtime": endTime,
        "reason": reason,
      };
}
