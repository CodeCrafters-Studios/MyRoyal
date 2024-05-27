import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:iroyal/app/modules/help-and-support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/app/modules/home/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/home/data/repositories/user_repository_impl.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/my_teams/data/repositories/my_teams_repository_impl.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/app/modules/my_teams/presentation/controllers/my_teams_controller.dart';
import 'package:iroyal/app/modules/notifications/presentation/controllers/notifications_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:iroyal/app/modules/settings/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/settings/data/repositories/settings_repository_impl.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/biometrics_app.dart';
import 'package:iroyal/app/modules/settings/domain/usecases/logout_app.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/webtel/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/webtel/data/repositories/webtel_repository_impl.dart';
import 'package:iroyal/app/modules/webtel/domain/usecases/get_webtel.dart';
import 'package:iroyal/app/modules/webtel/presentation/controllers/webtel_controller.dart';
import 'package:iroyal/base/utils/biometrics.dart';
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
          authBiometrics: Get.find<AuthBiometricsImpl>(),
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
      )

      //Profile
      ..lazyPut<ProfileController>(
        () => ProfileController(
          getProfile: Get.find(),
          getUser: Get.find(),
        ),
      )
      ..lazyPut<ProfileRemoteDataSourcesImpl>(
        () => ProfileRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<ProfileRepositoryImpl>(
        () => ProfileRepositoryImpl(
          remoteData: Get.find<ProfileRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetProfile(
          Get.find<ProfileRepositoryImpl>(),
        ),
      )

      //Webtel
      ..lazyPut<WebtelController>(
        () => WebtelController(
          getWebtel: Get.find(),
        ),
      )
      ..lazyPut<WebtelRemoteDataSourcesImpl>(
        () => WebtelRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<WebtelRepositoryImpl>(
        () => WebtelRepositoryImpl(
          remoteData: Get.find<WebtelRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetWebtel(
          Get.find<WebtelRepositoryImpl>(),
        ),
      )

      // Notifications
      ..lazyPut<NotificationsController>(
        () => NotificationsController(),
      )

      // Help & Support
      ..lazyPut<HelpAndSupportController>(
        () => HelpAndSupportController(),
      )

      // Tasks
      ..lazyPut<TasksController>(
        () => TasksController(appDialog: Get.find<AppDialogImpl>()),
      )

      // Detail Tasks
      ..lazyPut<DetailTasksController>(
        () => DetailTasksController(),
      )

      // Attendance
      ..lazyPut<AttendanceController>(
        () => AttendanceController(),
      );
  }
}
