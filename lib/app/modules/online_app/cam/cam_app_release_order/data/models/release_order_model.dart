import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/domain/entities/release_order_entity.dart';

class ReleaseOrderModel extends ReleaseOrderEntity {
  ReleaseOrderModel(
      {required super.code, required super.message, required super.data});

  factory ReleaseOrderModel.fromJson(Map<String, dynamic> json) =>
      ReleaseOrderModel(
        code: json["code"],
        message: json["message"],
        data: Data.fromJson(json["data"]),
      );

  factory ReleaseOrderModel.empty() => ReleaseOrderModel(
        code: 0,
        message: '',
        data: Data(
          status: false,
          order: '',
          data: [],
        ),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
