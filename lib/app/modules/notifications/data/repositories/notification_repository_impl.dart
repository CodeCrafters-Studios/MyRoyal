import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/notifications/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/notifications/data/models/notification_model.dart';
import 'package:MyRoyal/app/modules/notifications/data/models/tap_notification_model.dart';
import 'package:MyRoyal/app/modules/notifications/domain/repositories/notification_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class NotificationsRepositoryImpl implements NotificationRepository {
  NotificationsRepositoryImpl({required this.remoteData});

  final NotificationsDataSources remoteData;

  @override
  Future<Either<Failure, NotificationModel>> getNotifications(params) async {
    try {
      final r = await remoteData.getNotifications(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, TapNotificationModel>> tapNotifications(params) async {
    try {
      final r = await remoteData.tapNotification(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
