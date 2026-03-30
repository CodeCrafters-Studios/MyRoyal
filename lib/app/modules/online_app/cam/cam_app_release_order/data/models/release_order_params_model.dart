import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/domain/entities/release_order_params_entity.dart';

class ReleaseOrderParamsModel extends ReleaseOrderParamsEntity {
  ReleaseOrderParamsModel({required super.orderid, required super.company});

  factory ReleaseOrderParamsModel.fromJson(Map<String, dynamic> json) =>
      ReleaseOrderParamsModel(
        orderid: json["orderid"],
        company: json["company"],
      );

  Map<String, dynamic> toJson() => {
        "orderid": orderid,
        "company": company,
      };
}
