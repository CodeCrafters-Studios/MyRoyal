import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/update_release_order_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/repositories/release_order_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class UpdateReleaseOrderUsecase
    implements UseCase<UpdateReleaseOrderModel, UpdateReleaseOrderParamsModel> {
  UpdateReleaseOrderUsecase(this.repository);

  final ReleaseOrderRepository repository;

  @override
  Future<Either<Failure, UpdateReleaseOrderModel>> call(
      UpdateReleaseOrderParamsModel params) {
    return repository.updateReleaseOrder(params.toJson());
  }
}
