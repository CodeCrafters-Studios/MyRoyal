import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_model.dart';
import 'package:iroyal/base/errors/failures.dart';

abstract class ReleaseOrderRepository {
  Future<Either<Failure, ReleaseOrderModel>> getReleaseOrder(params);
  Future<Either<Failure, UpdateReleaseOrderModel>> updateReleaseOrder(params);
}
