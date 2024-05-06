import 'package:get/get.dart';
import 'package:iroyal/app/modules/login/data/datasources/login_local_data.dart';
import 'package:iroyal/app/modules/login/data/datasources/login_remote.data.dart';
import 'package:iroyal/app/modules/login/data/repositories/login_repository_impl.dart';
import 'package:iroyal/app/modules/login/domain/usecases/auth_biometrics_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_login_param.dart';
import 'package:iroyal/app/modules/login/domain/usecases/login_app.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/location/app_location.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(
        () => LoginLocalDataSourceImpl(
          // deviceInfo: Get.find(),
          biometrics: Get.find<AuthBiometricsImpl>(),
          appStorage: Get.find(),
          appLocation: Get.find<AppLocationImpl>(),
          // commonParam: Get.find<CommonParamsImpl>(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut(() => LoginRemoteDataSourceImpl(httpService: Get.find()))
      ..lazyPut<LoginRepositoryImpl>(
        () => LoginRepositoryImpl(
          localData: Get.find<LoginLocalDataSourceImpl>(),
          remoteData: Get.find<LoginRemoteDataSourceImpl>(),
        ),
      )
      ..lazyPut(() => LoginApp(Get.find<LoginRepositoryImpl>()))
      ..lazyPut(() => GetLoginParams(Get.find<LoginRepositoryImpl>()))
      ..lazyPut(() => GetCacheUserLogin(Get.find<LoginRepositoryImpl>()))
      ..lazyPut(() => AuthBiometricsLogin(Get.find<LoginRepositoryImpl>()))
      ..lazyPut(
        () => LoginController(
          getLoginParams: Get.find(),
          loginApp: Get.find(),
          getCacheUserLogin: Get.find(),
          authBiometricsLogin: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
          appStorage: Get.find(),
        ),
      );
  }
}
