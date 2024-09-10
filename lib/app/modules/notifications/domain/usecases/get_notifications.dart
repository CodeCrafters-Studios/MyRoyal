import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/notifications/domain/repositories/notifications_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetNotifications implements UseCase {
  GetNotifications(this.repository);

  final NotificationsRepository repository;

  @override
  Future<Either<Failure, dynamic>> call(params) {
    return repository.getNotifications(params);
  }
}
