import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/models/permit_model.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/action_form_leave_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/create_form_permit_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/repositories/leave_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

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
  Future<Either<Failure, ActionFormLeaveEntity>> actionFormLeave(
      Map<String, dynamic> actionFormLeaveParams) async {
    try {
      final r = await remoteData.actionFormLeave(actionFormLeaveParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, CreateFormPermitEntity>> createFormPermit(
      Map<String, dynamic> createFormPermitParams) async {
    try {
      final r = await remoteData.createFormPermit(createFormPermitParams);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, PermitModel>> getPermit() async {
    try {
      final r = await remoteData.getPermit();
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
