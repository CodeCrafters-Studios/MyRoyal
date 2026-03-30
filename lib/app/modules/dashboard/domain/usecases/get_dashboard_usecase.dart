import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetDashboardUsecase implements UseCaseNoParams {
  GetDashboardUsecase(this.repository);

  final DashboardRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getDashboardUseCase();
  }
}
