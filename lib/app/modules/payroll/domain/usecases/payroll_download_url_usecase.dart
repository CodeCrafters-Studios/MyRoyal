import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_period_params_model.dart';
import 'package:MyRoyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:MyRoyal/base/errors/failures.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';

class PayrollDownloadUrlUsecase
    implements UseCase<void, PayrollPeriodParamsModel> {
  PayrollDownloadUrlUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.payrollDownloadUrl(params.toJson());
  }
}
