import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/notifications/domain/repositories/notification_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class TapNotification implements UseCase {
  TapNotification(this.repository);

  final NotificationRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.tapNotifications(params);
  }
}
