import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/notifications/domain/repositories/notifications_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class TapNotification implements UseCase {
  TapNotification(this.repository);

  final NotificationsRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.tapNotifications(params);
  }
}
