import 'package:get/get.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/data/repositories/reserved_by_repository_impl.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/get_reserved_by_usecase.dart';
import 'package:iroyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/update_reserved_by_usecase.dart';

import '../controllers/cam_app_reserved_by_controller.dart';

class CamAppReservedByBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<ReservedByRemoteDatasoureceImpl>(
        () => ReservedByRemoteDatasoureceImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<ReservedByRepositoryImpl>(
        () => ReservedByRepositoryImpl(
            remoteData: Get.find<ReservedByRemoteDatasoureceImpl>()),
      )
      ..lazyPut<UpdateReservedByUsecase>(
        () => UpdateReservedByUsecase(Get.find<ReservedByRepositoryImpl>()),
      )
      ..lazyPut<GetReservedByUsecase>(
        () => GetReservedByUsecase(Get.find<ReservedByRepositoryImpl>()),
      )
      ..lazyPut<CamAppReservedByController>(
        () => CamAppReservedByController(
          getReservedByUsecase: Get.find<GetReservedByUsecase>(),
          updateReservedByUsecase: Get.find<UpdateReservedByUsecase>(),
          appStorage: Get.find(),
        ),
      );
  }
}
