import 'package:MyRoyal/app/modules/notifications/domain/entities/notification_data_list_entities.dart';

class NotificationDataListModel extends NotificationDataListEntities {
  const NotificationDataListModel({
    required super.id,
    required super.createdAt,
    required super.route,
    required super.body,
    required super.title,
    required super.isRead,
  });

  factory NotificationDataListModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataListModel(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        route: json["route"],
        body: json["body"],
        title: json["title"],
        isRead: json['read_at'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "route": route,
        "body": body,
        "title": title,
        "read_at": isRead
      };
}
