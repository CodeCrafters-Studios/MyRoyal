import 'package:iroyal/app/modules/notifications/data/models/notification_data_list_model.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_data_entities.dart';

class NotificationDataModel extends NotificationDataEntities {
  const NotificationDataModel({
    required super.currentPage,
    required super.data,
    required super.totalPage,
  });

  factory NotificationDataModel.fromJson(Map<String, dynamic> json) =>
      NotificationDataModel(
        currentPage: json["current_page"],
        data: List<NotificationDataListModel>.from(
            json["data"].map((x) => NotificationDataListModel.fromJson(x))),
        totalPage: json["total_page"],
      );

  Map<String, dynamic> toJson() => {
        "current_page": currentPage,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
        "total_page": totalPage,
      };
}
