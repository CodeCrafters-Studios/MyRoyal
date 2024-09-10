import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_data_list_model.dart';

class NotificationDataEntities extends Equatable {
  const NotificationDataEntities({
    required this.currentPage,
    required this.data,
    required this.totalPage,
  });

  final int currentPage;
  final List<NotificationDataListModel> data;
  final int totalPage;

  @override
  List<Object?> get props => [currentPage, data, totalPage];
}
