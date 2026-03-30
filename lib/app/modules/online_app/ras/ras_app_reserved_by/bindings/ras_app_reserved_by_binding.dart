import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/data/repositories/reserved_by_repository_impl.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/get_reserved_by_usecase.dart';
import 'package:MyRoyal/app/modules/online_app/cam/cam_app_reserved_by/domain/usecases/update_reserved_by_usecase.dart';

import '../controllers/ras_app_reserved_by_controller.dart';

class RasAppReservedByBinding extends Bindings {
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
      ..lazyPut<RasAppReservedByController>(
        () => RasAppReservedByController(
          getReservedByUsecase: Get.find<GetReservedByUsecase>(),
          updateReservedByUsecase: Get.find<UpdateReservedByUsecase>(),
          appStorage: Get.find(),
        ),
      );
  }
}
