import 'package:iroyal/app/modules/notifications/domain/entities/tap_notification_data_entities.dart';

class TapNotificationDataModel extends TapNotificationDataEntities {
  const TapNotificationDataModel(super.id, super.recipientType, super.route);

  factory TapNotificationDataModel.fromJson(Map<String, dynamic> json) =>
      TapNotificationDataModel(
          json["id"], json["recipient_type"], json["route"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "recipient_type": recipientType,
        "route": route,
      };
}
