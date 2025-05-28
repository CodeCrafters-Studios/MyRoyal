import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_params_model.dart';
import 'package:iroyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class PayrollDownloadUrlUsecase
    implements UseCase<void, PayrollPeriodParamsModel> {
  PayrollDownloadUrlUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, void>> call(params) {
    return repository.payrollDownloadUrl(params.toJson());
  }
}
