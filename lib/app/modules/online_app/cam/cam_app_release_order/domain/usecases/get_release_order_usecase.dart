import 'package:dartz/dartz.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/data/models/release_order_params_model.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_release_order/domain/repositories/release_order_repository.dart';
import 'package:iroyal/base/errors/failures.dart';
import 'package:iroyal/base/usecases/usecase.dart';

class GetReleaseOrderUsecase
    implements UseCase<ReleaseOrderModel, ReleaseOrderParamsModel> {
  GetReleaseOrderUsecase(this.repository);

  final ReleaseOrderRepository repository;

  @override
  Future<Either<Failure, ReleaseOrderModel>> call(
      ReleaseOrderParamsModel params) {
    return repository.getReleaseOrder(params.toJson());
  }
}
