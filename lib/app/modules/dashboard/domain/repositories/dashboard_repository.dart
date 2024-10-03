import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class DashboardRepository {
  Future<Either<Failure, DashboardModel>> getDashboardUseCase();
}
