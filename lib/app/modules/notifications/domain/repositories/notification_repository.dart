import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/notifications/data/models/notification_model.dart';
import 'package:MyRoyal/app/modules/notifications/data/models/tap_notification_model.dart';
import 'package:MyRoyal/base/errors/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, NotificationModel>> getNotifications(params);
  Future<Either<Failure, TapNotificationModel>> tapNotifications(params);
}
