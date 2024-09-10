import 'package:equatable/equatable.dart';
import 'package:iroyal/app/modules/notifications/data/models/tap_notification_data_model.dart';

class TapNotificationEntities extends Equatable {
  const TapNotificationEntities(this.code, this.message, this.data);

  final int code;
  final String message;
  final TapNotificationDataModel data;

  @override
  List<Object?> get props => [code, message, data];
}
