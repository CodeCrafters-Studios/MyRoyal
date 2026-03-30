import 'package:MyRoyal/app/modules/leave_summary/data/models/permit_data_model.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/permit_entity.dart';

class PermitModel extends PermitEntity {
  const PermitModel(
      {required super.code, required super.message, required super.data});

  factory PermitModel.fromJson(Map<String, dynamic> json) => PermitModel(
        code: json["code"],
        message: json["message"],
        data: List<PermitDataModel>.from(
            json["data"].map((x) => PermitDataModel.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}
