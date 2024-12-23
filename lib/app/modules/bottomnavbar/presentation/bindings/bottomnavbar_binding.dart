import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance/controllers/attendance_controller.dart';
import 'package:iroyal/app/modules/dashboard/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_detail_late_usecase.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_detail_permit_request_usecase.dart';
import 'package:iroyal/app/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:iroyal/app/modules/help_and_support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/app/modules/home/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/home/data/repositories/user_repository_impl.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_user.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/cancel_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/my_teams/data/repositories/my_teams_repository_impl.dart';
import 'package:iroyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:iroyal/app/modules/my_teams/presentation/controllers/my_teams_controller.dart';
import 'package:iroyal/app/modules/notifications/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/notifications/data/repositories/notifications_repository_impl.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/tap_notification.dart';
import 'package:iroyal/app/modules/notifications/presentation/controllers/notifications_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
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
import 'package:iroyal/base/initialization/firebase_remote_config.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
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
          getNotifications: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
          deviceInfo: Get.find<DeviceInfo>(),
          firebaseRemoteConfig: Get.find<MellotippetFirebaseRemoteConfig>(),
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
      ..lazyPut(
        () => GetCacheUser(
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
          getCacheUser: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
          downloadFile: Get.find(),
        ),
      )
      ..lazyPut<ProfileLocalDataSourcesImpl>(
        () => ProfileLocalDataSourcesImpl(
          appPermission: Get.find<AppPermissionImpl>(),
          dio: Get.find(),
        ),
      )
      ..lazyPut<ProfileRemoteDataSourcesImpl>(
        () => ProfileRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<ProfileRepositoryImpl>(
        () => ProfileRepositoryImpl(
          localData: Get.find<ProfileLocalDataSourcesImpl>(),
          remoteData: Get.find<ProfileRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => DownloadFile(
          Get.find<ProfileRepositoryImpl>(),
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
        () => NotificationsController(
            getNotifications: Get.find(), tapNotification: Get.find()),
      )
      ..lazyPut<NotificationsRemoteDataSourcesImpl>(
        () => NotificationsRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<NotificationsRepositoryImpl>(
        () => NotificationsRepositoryImpl(
          remoteData: Get.find<NotificationsRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetNotifications(
          Get.find<NotificationsRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => TapNotification(
          Get.find<NotificationsRepositoryImpl>(),
        ),
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
      )

      // Dashboard
      ..lazyPut<DashboardRemoteDataSourceImpl>(
          () => DashboardRemoteDataSourceImpl(httpService: Get.find()))
      ..lazyPut<DashboardRepositoryImpl>(() => DashboardRepositoryImpl(
          remoteData: Get.find<DashboardRemoteDataSourceImpl>()))
      ..lazyPut<GetDashboardUsecase>(
          () => GetDashboardUsecase(Get.find<DashboardRepositoryImpl>()))
      ..lazyPut<GetDetailLateUsecase>(
          () => GetDetailLateUsecase(Get.find<DashboardRepositoryImpl>()))
      ..lazyPut<GetDetailPermitRequestUsecase>(() =>
          GetDetailPermitRequestUsecase(Get.find<DashboardRepositoryImpl>()))
      ..lazyPut<DashboardController>(
        () => DashboardController(
          getUser: Get.find(),
          getDashboard: Get.find(),
          getDetailLateUsecase: Get.find(),
          getDetailPermitRequestUsecase: Get.find(),
        ),
      )

      // Leave Summary
      ..lazyPut<LeaveRemoteDataSourcesImpl>(
        () => LeaveRemoteDataSourcesImpl(httpService: Get.find()),
      )
      ..lazyPut<LeaveRepositoryImpl>(
        () => LeaveRepositoryImpl(
            remoteData: Get.find<LeaveRemoteDataSourcesImpl>()),
      )
      ..lazyPut<GetLeaveUsecase>(
        () => GetLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<GetSubtituteEmployeeUsecase>(
        () => GetSubtituteEmployeeUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<CreateFormLeaveUsecase>(
        () => CreateFormLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<CancelFormLeaveUsecase>(
        () => CancelFormLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<CreateFormPermitUsecase>(
        () => CreateFormPermitUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<GetPermitUsecase>(
        () => GetPermitUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<LeaveSummaryController>(
        () => LeaveSummaryController(
          getLeaveUsecase: Get.find<GetLeaveUsecase>(),
          getPermitUsecase: Get.find<GetPermitUsecase>(),
          getSubtituteEmployeeUsecase: Get.find<GetSubtituteEmployeeUsecase>(),
          createFormLeaveUsecase: Get.find<CreateFormLeaveUsecase>(),
          cancelFormLeaveUsecase: Get.find<CancelFormLeaveUsecase>(),
          getCacheUser: Get.find<GetCacheUser>(),
          createFormPermitUsecase: Get.find<CreateFormPermitUsecase>(),
        ),
      );
  }
}
