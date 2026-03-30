import 'package:MyRoyal/app/modules/dashboard/data/models/dashboard_data_model.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/entities/dashboard_entity.dart';

class DashboardModel extends DashboardEntity {
  const DashboardModel(
      {required super.code, required super.message, required super.data});

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
        code: json["code"],
        message: json["message"],
        data: json["data"] == null
            ? null
            : DashboardDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data?.toJson(),
      };
}
