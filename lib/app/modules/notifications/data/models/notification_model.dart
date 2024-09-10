import 'package:iroyal/app/modules/notifications/data/models/notification_data_model.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_entities.dart';

class NotificatiosnModel extends NotificationEntities {
  const NotificatiosnModel(
      {required super.code, required super.message, required super.data});

  factory NotificatiosnModel.fromJson(Map<String, dynamic> json) =>
      NotificatiosnModel(
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
