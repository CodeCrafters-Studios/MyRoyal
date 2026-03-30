import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/data/repositories/release_order_repository_impl.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/domain/usecases/get_release_order_usecase.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_release_order/domain/usecases/update_release_order_usecase.dart';

import '../controllers/cam_app_release_order_controller.dart';

class CamAppReleaseOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<ReleaseOrderRemoteDatasourceImpl>(
        () => ReleaseOrderRemoteDatasourceImpl(
          Get.find(),
        ),
      )
      ..lazyPut<ReleaseOrderRepositoryImpl>(
        () => ReleaseOrderRepositoryImpl(
            Get.find<ReleaseOrderRemoteDatasourceImpl>()),
      )
      ..lazyPut<UpdateReleaseOrderUsecase>(
        () => UpdateReleaseOrderUsecase(Get.find<ReleaseOrderRepositoryImpl>()),
      )
      ..lazyPut<GetReleaseOrderUsecase>(
        () => GetReleaseOrderUsecase(Get.find<ReleaseOrderRepositoryImpl>()),
      )
      ..lazyPut<CamAppReleaseOrderController>(
        () => CamAppReleaseOrderController(
          getReleaseOrderUsecase: Get.find<GetReleaseOrderUsecase>(),
          updateReleaseOrderUsecase: Get.find<UpdateReleaseOrderUsecase>(),
          appStorage: Get.find(),
        ),
      );
  }
}
