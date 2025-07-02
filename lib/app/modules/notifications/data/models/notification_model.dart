import 'package:iroyal/app/modules/notifications/data/models/notification_data_model.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_entities.dart';

class NotificationModel extends NotificationEntities {
  const NotificationModel(
      {required super.code, required super.message, required super.data});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        code: json["code"],
        message: json["message"],
        data: NotificationDataModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code,
        "message": message,
        "data": data.toJson(),
      };
}
