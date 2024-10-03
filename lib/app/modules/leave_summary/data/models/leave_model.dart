import 'package:iroyal/app/modules/leave_summary/data/models/leave_data_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/leave_entity.dart';

class LeaveModel extends LeaveEntity {
  const LeaveModel(
      {required super.code, required super.message, required super.data});

  factory LeaveModel.fromJson(Map<String, dynamic> json) => LeaveModel(
        code: json["code"],
        message: json["message"],
        data:
            json["data"] == null ? null : LeaveDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}
