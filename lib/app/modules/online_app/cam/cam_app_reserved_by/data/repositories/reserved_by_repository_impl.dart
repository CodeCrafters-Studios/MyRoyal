import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/reserved_by_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/models/update_reserved_by_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/domain/repositories/reserved_by_repository.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/errors/failures.dart';

class ReservedByRepositoryImpl implements ReservedByRepository {
  ReservedByRepositoryImpl({required this.remoteData});

  final ReservedByRemoteDatasource remoteData;

  @override
  Future<Either<Failure, ReservedByModel>> getReservedBy(params) async {
    try {
      final r = await remoteData.getReservedBy(params);
      return Right(r);
    } on ApiException {
      return const Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, UpdateReservedByModel>> updateReservedBy(
      params) async {
    try {
      final r = await remoteData.updateReservedBy(params);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
