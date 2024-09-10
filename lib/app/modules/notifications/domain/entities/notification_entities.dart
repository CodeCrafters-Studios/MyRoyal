import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_data_model.dart';

class NotificationEntities extends Equatable {
  const NotificationEntities(
      {required this.code, required this.message, required this.data});

  final int code;
  final String message;
  final NotificationDataModel data;

  @override
  List<Object?> get props => [code, message, data];
}
