import 'package:MyRoyal/app/modules/ocr/data/models/data_master_employee_os_model.dart';
import 'package:MyRoyal/app/modules/ocr/models/employee_os_model.dart';
import 'package:dartz/dartz.dart';
import 'package:MyRoyal/app/modules/ocr/data/datasources/ocr_remote_data_source.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/scan_ocr_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_request_model.dart';
import 'package:MyRoyal/app/modules/ocr/data/models/save_employee_os_response_model.dart';
import 'package:MyRoyal/app/modules/ocr/domain/repositories/ocr_repository.dart';
import 'package:MyRoyal/base/errors/exception.dart';
import 'package:MyRoyal/base/errors/failures.dart';

class OcrRepositoryImpl implements OcrRepository {
  final OcrRemoteDataSource remoteDataSource;

  OcrRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ScanOcrResponseModel>> scanOcr(
      ScanOcrRequestModel request) async {
    try {
      final result = await remoteDataSource.scanOcr(request);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(properties: [e.message ?? 'Server error']));
    } catch (e) {
      return Left(ServerFailure(properties: [e.toString()]));
    }
  }

  @override
  Future<Either<Failure, EmployeeOsModel>> getEmployeeOs(params) async {
    try {
      final result = await remoteDataSource.getEmployeeOs(params);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(properties: [e.message ?? 'Server error']));
    } catch (e) {
      return Left(ServerFailure(properties: [e.toString()]));
    }
  }

  @override
  Future<Either<Failure, DataMasterEmployeeOsModel>>
      getDataMasterEmployeeOs() async {
    try {
      final result = await remoteDataSource.getDataMasterEmployeeOs();
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(properties: [e.message ?? 'Server error']));
    } catch (e) {
      return Left(ServerFailure(properties: [e.toString()]));
    }
  }

  @override
  Future<Either<Failure, SaveEmployeeOsResponseModel>> saveEmployeeOs(
      SaveEmployeeOsRequestModel request) async {
    try {
      final result = await remoteDataSource.saveEmployeeOs(request);
      return Right(result);
    } on ApiException catch (e) {
      return Left(ServerFailure(properties: [e.message ?? 'Server error']));
    } catch (e) {
      return Left(ServerFailure(properties: [e.toString()]));
    }
  }
}
