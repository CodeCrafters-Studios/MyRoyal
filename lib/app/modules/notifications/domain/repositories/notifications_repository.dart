import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_model.dart';
import 'package:iroyal/app/modules/notifications/data/models/tap_notification_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class NotificationsRepository {
  Future<Either<Failure, NotificatiosnModel>> getNotifications(params);
  Future<Either<Failure, TapNotificationModel>> tapNotifications(params);
}
