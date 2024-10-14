import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_approval_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class LeaveRepositoryImpl implements LeaveRepository {
  LeaveRepositoryImpl({required this.remoteData});

  final LeaveRemoteDataSources remoteData;

  @override
  Future<Either<Failure, LeaveModel>> getLeave() async {
    try {
      final r = await remoteData.getLeave();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, SubtituteEmployeeEntity>>
      getSubtituteEmployee() async {
    try {
      final r = await remoteData.getSubtituteEmployee();
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, CreateFormLeaveEntity>> createFormLeave(
      Map<String, dynamic> createFormLeaveParams) async {
    try {
      final r = await remoteData.createFormLeave(createFormLeaveParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, CancelFormLeaveEntity>> cancelFormLeave(
      Map<String, dynamic> cancelFormLeaveParams) async {
    try {
      final r = await remoteData.cancelFormLeave(cancelFormLeaveParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, List<LeaveApprovalModel>>> getLeaveApproval() async {
    try {
      final r = await remoteData.getLeaveApproval();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
