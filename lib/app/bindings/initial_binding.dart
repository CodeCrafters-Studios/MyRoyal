import 'package:get/get.dart';
import 'package:iroyal/app/controllers/user_info_controller.dart';
import 'package:iroyal/app/controllers/utility_controller.dart';
import 'package:iroyal/app/data/common_parameter.dart';
import 'package:iroyal/app/shared/data/datasources/local_data.dart';
import 'package:iroyal/app/shared/data/datasources/remote_data.dart';
import 'package:iroyal/app/shared/data/repositories/global_repository_impl.dart';
import 'package:iroyal/app/shared/domain/usecases/get_cache_login.dart';

class InitialBinding extends Bindings {
  @override
  Future<void> dependencies() async {
    Get
      ..put(UserInfoController())
      ..put(UtilityController())

      //GLOBAL
      ..put(GlobalLocalDataImpl(appStorage: Get.find()))
      ..put(
        GlobalRemoteDataImpl(
          commonParam: Get.find<CommonParamsImpl>(),
          http: Get.find(),
          appStorage: Get.find(),
          deviceInfo: Get.find(),
        ),
      )
      ..put(
        GlobalRepositoryImpl(
          localData: Get.find<GlobalLocalDataImpl>(),
          remoteData: Get.find<GlobalRemoteDataImpl>(),
        ),
      )
      ..put(GetCacheLogin(Get.find<GlobalRepositoryImpl>()));
    // ..put(VerifyToken(Get.find<GlobalRepositoryImpl>()))
    // ..put(GetRefreshToken(Get.find<GlobalRepositoryImpl>()))
    // ..put(GetLanguage(Get.find<GlobalRepositoryImpl>()))
  }
}
