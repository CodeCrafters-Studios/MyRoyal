import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/repositories/release_order_repository.dart';
import 'package:iroyal/base/errors/failures.dart';

class ReleaseOrderRepositoryImpl implements ReleaseOrderRepository {
  ReleaseOrderRepositoryImpl(this.remoteData);

  final ReleaseOrderRemoteDatasource remoteData;

  @override
  Future<Either<Failure, ReleaseOrderModel>> getReleaseOrder(params) async {
    try {
      final r = await remoteData.getReleaseOrder(params);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }

  @override
  Future<Either<Failure, UpdateReleaseOrderModel>> updateReleaseOrder(
      params) async {
    try {
      final r = await remoteData.updateReleaseOrder(params);
      return Right(r);
    } catch (e) {
      return Left(ServerFailure(properties: [e]));
    }
  }
}
