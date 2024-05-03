import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/home/data/repositories/user_repository_impl.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/my_teams/data/repositories/my_teams_repository_impl.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/app/modules/my_teams/presentation/controllers/my_teams_controller.dart';
import 'package:iroyal/app/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:iroyal/app/modules/settings/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/settings/data/repositories/settings_repository_impl.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/biometrics_app.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/logout_app.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

import '../controllers/bottomnavbar_controller.dart';

class BottomnavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<BottomnavbarController>(
        () => BottomnavbarController(),
      )

      // Home
      ..lazyPut<HomeController>(
        () => HomeController(
          getUser: Get.find(),
        ),
      )
      ..lazyPut<HomeLocalDataSourceImpl>(
        () => HomeLocalDataSourceImpl(
          appStorage: Get.find(),
        ),
      )
      ..lazyPut<HomeRemoteDataSourceImpl>(
        () => HomeRemoteDataSourceImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<HomeRepositoryImpl>(
        () => HomeRepositoryImpl(
          localData: Get.find<HomeLocalDataSourceImpl>(),
          remoteData: Get.find<HomeRemoteDataSourceImpl>(),
        ),
      )
      ..lazyPut(
        () => GetUser(
          Get.find<HomeRepositoryImpl>(),
        ),
      )

      // Settings
      ..lazyPut(
        () => SettingsLocalDataImpl(
          appStorage: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut(
        () => SettingsRepositoryImpl(
          localData: Get.find<SettingsLocalDataImpl>(),
        ),
      )
      ..lazyPut(
        () => LogoutApp(
          Get.find<SettingsRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => BiometricsApp(
          Get.find<SettingsRepositoryImpl>(),
          Get.find<AppStorage>(),
        ),
      )
      ..lazyPut(
        () => SettingsController(
          getUser: Get.find(),
          // getCacheLogin: Get.find(),
          logoutApp: Get.find(),
          appStorage: Get.find(),
          biometricsApp: Get.find(),
        ),
      )

      // My Teams
      ..lazyPut<MyTeamsController>(
        () => MyTeamsController(
          getMyTeams: Get.find(),
          getUser: Get.find(),
        ),
      )
      ..lazyPut<MyTeamsRemoteDataSourcesImpl>(
        () => MyTeamsRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<MyTeamsRepositoryImpl>(
        () => MyTeamsRepositoryImpl(
          remoteData: Get.find<MyTeamsRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetMyTeams(
          Get.find<MyTeamsRepositoryImpl>(),
        ),
      );
  }
}
