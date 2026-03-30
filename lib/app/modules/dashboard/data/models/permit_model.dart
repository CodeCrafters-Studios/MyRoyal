import 'package:MyRoyal/app/modules/dashboard/domain/entities/permit_entity.dart';

class DashboardPermitModel extends DashboardPermitEntity {
  const DashboardPermitModel({required super.count});

  factory DashboardPermitModel.fromJson(Map<String, dynamic> json) =>
      DashboardPermitModel(
        count: json["count"],
      );

  Map<String, dynamic> toJson() => {
        "count": count,
      };
}
