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
import 'package:iroyal/app/modules/profile/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/biometrics_app.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/logout_app.dart';
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

      // Profile
      ..lazyPut(
        () => ProfileLocalDataImpl(
          appStorage: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut(
        () =>
            ProfileRepositoryImpl(localData: Get.find<ProfileLocalDataImpl>()),
      )
      ..lazyPut(() => LogoutApp(Get.find<ProfileRepositoryImpl>()))
      ..lazyPut(() => BiometricsApp(
          Get.find<ProfileRepositoryImpl>(), Get.find<AppStorage>()))
      ..lazyPut(
        () => ProfileController(
            getUser: Get.find(),
            // getCacheLogin: Get.find(),
            logoutApp: Get.find(),
            appStorage: Get.find(),
            biometricsApp: Get.find()),
      )

      // My Teams
      ..lazyPut<MyTeamsController>(
        () => MyTeamsController(getMyTeams: Get.find()),
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
        () => GetMyTeams(Get.find<MyTeamsRepositoryImpl>()),
      );
  }
}
