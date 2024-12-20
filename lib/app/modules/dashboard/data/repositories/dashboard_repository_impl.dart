import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/dashboard/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/dashboard/data/models/dashboard_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_late_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_permit_request_model.dart';
import 'package:iroyal/app/modules/dashboard/data/models/detail_special_leave_request_model.dart';
import 'package:iroyal/app/modules/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl({required this.remoteData});

  final DashboardRemoteDataSource remoteData;

  @override
  Future<Either<Failure, DashboardModel>> getDashboardUseCase() async {
    try {
      final r = await remoteData.getDashboard();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DetailLateModel>> getDetailLateUseCase() async {
    try {
      final r = await remoteData.getDetailLate();
      return Right(r);
    } on ApiException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DetailPermitRequestModel>>
      getDetailPermitRequestUseCase() async {
    try {
      final r = await remoteData.getDetailPermitRequest();
      return Right(r);
    } on ApiException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, DetailSpecialLeaveRequestModel>>
      getDetailSpecialLeaveRequestUseCase() async {
    try {
      final r = await remoteData.getDetailSpecialLeaveRequest();
      return Right(r);
    } on ApiException {
      return Left(ServerFailure());
    }
  }
}
