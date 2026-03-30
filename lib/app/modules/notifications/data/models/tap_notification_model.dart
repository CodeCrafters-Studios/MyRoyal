import 'package:MyRoyal/app/modules/notifications/data/models/tap_notification_data_model.dart';
import 'package:MyRoyal/app/modules/notifications/domain/entities/tap_notification_entities.dart';

class TapNotificationModel extends TapNotificationEntities {
  const TapNotificationModel(super.code, super.message, super.data);

  factory TapNotificationModel.fromJson(Map<String, dynamic> json) =>
      TapNotificationModel(
        json["code"],
        json["message"],
        TapNotificationDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
