import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetPayrollPeriodeUsecase implements UseCaseNoParams {
  GetPayrollPeriodeUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, dynamic>> call() {
    return repository.getPayrollPeriod();
  }
}
