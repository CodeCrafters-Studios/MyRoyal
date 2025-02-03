import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_id_params_model.dart';
import 'package:iroyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class PayrollDataOverviewUsecase
    implements UseCase<PayrollDataOverviewModel, PayrollIdParamsModel> {
  PayrollDataOverviewUsecase(this.repository);

  final PayrollPeriodRepository repository;

  @override
  Future<Either<Failure, PayrollDataOverviewModel>> call(params) {
    return repository.payrollDataOverview(params.toJson());
  }
}
