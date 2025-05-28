import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:iroyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class PayrollPeriodRepository {
  Future<Either<Failure, PayrollPeriodModel>> getPayrollPeriod();
  Future<Either<Failure, void>> payrollDownloadUrl(
    Map<String, dynamic> params,
  );
  Future<Either<Failure, PayrollDataOverviewModel>> payrollDataOverview(
    Map<String, dynamic> params,
  );
}
