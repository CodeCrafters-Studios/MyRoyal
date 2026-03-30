import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/domain/entities/update_release_order_entity.dart';

class UpdateReleaseOrderModel extends UpdateReleaseOrderEntity {
  UpdateReleaseOrderModel(
      {required super.code, required super.message, required super.data});

  factory UpdateReleaseOrderModel.fromJson(Map<String, dynamic> json) =>
      UpdateReleaseOrderModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
