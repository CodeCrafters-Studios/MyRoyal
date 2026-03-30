import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/payroll/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_data_overview_model.dart';
import 'package:MyRoyal/app/modules/payroll/data/models/payroll_period_model.dart';
import 'package:MyRoyal/app/modules/payroll/domain/repositories/payroll_period_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class PayrollPeriodRepositoryImpl implements PayrollPeriodRepository {
  final PayrollRemoteDataSources remoteData;

  PayrollPeriodRepositoryImpl({required this.remoteData});
  @override
  Future<Either<Failure, PayrollPeriodModel>> getPayrollPeriod() async {
    try {
      final r = await remoteData.getPayrollPeriod();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> payrollDownloadUrl(params) async {
    try {
      await remoteData.payrollDownloadUrl(params);
      return const Right(null);
    } catch (e) {
      return Left(
        ServerFailure(properties: [e]),
      );
    }
  }

  @override
  Future<Either<Failure, PayrollDataOverviewModel>> payrollDataOverview(
      Map<String, dynamic> params) async {
    try {
      final r = await remoteData.payrollDataOverview(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }
}
