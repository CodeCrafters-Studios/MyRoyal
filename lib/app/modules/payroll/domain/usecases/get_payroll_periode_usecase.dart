import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class GetPayrollPeriodeUsecase implements UseCaseNoParams {
  GetPayrollPeriodeUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getPayrollPeriod();
  }
}
