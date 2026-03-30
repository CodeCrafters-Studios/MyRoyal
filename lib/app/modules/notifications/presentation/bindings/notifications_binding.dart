import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/attendance/data/datasources/attendance_remote_data_source.dart';
import 'package:MyRoyal/app/modules/attendance/data/repositories/attendance_repository_impl.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_location_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/get_attendance_today_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/domain/usecases/record_attendance_usecase.dart';
import 'package:MyRoyal/app/modules/attendance/presentation/controllers/attendance_controller.dart';
import 'package:MyRoyal/app/modules/bottomnavbar/presentation/controllers/bottomnavbar_controller.dart';
import 'package:MyRoyal/app/modules/dashboard/data/datasources/remote_datasource.dart';
import 'package:MyRoyal/app/modules/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_late_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_permit_request_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_special_leave_request_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:MyRoyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:MyRoyal/app/modules/help_and_support/controllers/help_and_support_controller.dart';
import 'package:MyRoyal/app/modules/home/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/home/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/home/data/repositories/home_repository_impl.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_articles_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_banner_event_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_cache_user_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_user_usecase.dart';
import 'package:MyRoyal/app/modules/home/domain/usecases/get_user_jde_usecase.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/action_form_leave_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/create_form_permit_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/get_permit_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:MyRoyal/app/modules/my_teams/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/my_teams/data/repositories/my_teams_repository_impl.dart';
import 'package:MyRoyal/app/modules/my_teams/domain/usecases/get_my_teams.dart';
import 'package:MyRoyal/app/modules/my_teams/presentation/controllers/my_teams_controller.dart';
import 'package:MyRoyal/app/modules/notifications/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/notifications/data/repositories/notification_repository_impl.dart';
import 'package:MyRoyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:MyRoyal/app/modules/notifications/domain/usecases/tap_notification.dart';
import 'package:MyRoyal/app/modules/payroll/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/payroll/data/repositories/payroll_period_repository_impl.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/presentation/controllers/payroll_controller.dart';
import 'package:MyRoyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/app/modules/settings/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/settings/data/repositories/settings_repository_impl.dart';
import 'package:MyRoyal/app/modules/settings/domain/usecases/biometrics_app.dart';
import 'package:MyRoyal/app/modules/settings/domain/usecases/logout_app.dart';
import 'package:MyRoyal/app/modules/settings/presentation/controllers/settings_controller.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:MyRoyal/app/modules/webtel/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/webtel/data/repositories/webtel_repository_impl.dart';
import 'package:MyRoyal/app/modules/webtel/domain/usecases/get_webtel.dart';
import 'package:MyRoyal/app/modules/webtel/presentation/controllers/webtel_controller.dart';
import 'package:MyRoyal/base/initialization/firebase_remote_config.dart';
import 'package:MyRoyal/base/services/http_service.dart';
import 'package:MyRoyal/base/utils/biometrics.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/permission/app_permission.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';

import '../controllers/notifications_controller.dart';

class NotificationsBinding extends Bindings {
  @override
  void dependencies() {
    Get
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

      // BottomNav
      ..lazyPut<BottomnavbarController>(
        () => BottomnavbarController(),
      )

      // Home
      ..lazyPut<HomeController>(
        () => HomeController(
          getUserUsecase: Get.find<GetUserUsecase>(),
          appDialog: Get.find<AppDialogImpl>(),
          deviceInfo: Get.find<DeviceInfo>(),
          firebaseRemoteConfig: Get.find<MellotippetFirebaseRemoteConfig>(),
          appStorage: Get.find(),
          getArticlesUsecase: Get.find<GetArticlesUsecase>(),
          getUserJdeUsecase: Get.find<GetUserJdeUsecase>(),
          getBannerEventUsecase: Get.find<GetBannerEventUsecase>(),
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
        () => GetCacheUserUsecase(
          Get.find<HomeRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => GetArticlesUsecase(
          Get.find<HomeRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => GetUserJdeUsecase(
          Get.find<HomeRepositoryImpl>(),
        ),
      )
      ..lazyPut(
        () => GetBannerEventUsecase(
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
          // getCacheLogin: Get.find(),
          logoutApp: Get.find(),
          appStorage: Get.find(),
          biometricsApp: Get.find(),
          authBiometrics: Get.find<AuthBiometricsImpl>(),
          deviceInfo: Get.find(),
        ),
      )

      // My Teams
      ..lazyPut<MyTeamsController>(
        () => MyTeamsController(
          getMyTeams: Get.find(),
          getCacheUser: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
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
          appDialog: Get.find<AppDialogImpl>(),
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
      ..lazyPut<AttendanceRemoteDataSourceImpl>(
        () => AttendanceRemoteDataSourceImpl(
          httpService: Get.find<HttpService>(),
        ),
      )
      ..lazyPut<AttendanceRepositoryImpl>(
        () => AttendanceRepositoryImpl(
            remoteDataSource: Get.find<AttendanceRemoteDataSourceImpl>()),
      )
      ..lazyPut<RecordAttendanceUsecase>(
        () => RecordAttendanceUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<GetAttendanceTodayUsecase>(
        () => GetAttendanceTodayUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<GetAttendanceTodayUsecase>(
        () => GetAttendanceTodayUsecase(
          repository: Get.find<AttendanceRepositoryImpl>(),
        ),
      )
      ..lazyPut<AttendanceController>(
        () => AttendanceController(
            getAttendanceTodayUsecase: Get.find<GetAttendanceTodayUsecase>(),
            recordAttendanceUsecase: Get.find<RecordAttendanceUsecase>(),
            getAttendanceLocationUsecase:
                Get.find<GetAttendanceLocationUsecase>()),
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
      ..lazyPut<GetDetailSpecialLeaveRequestUsecase>(() =>
          GetDetailSpecialLeaveRequestUsecase(
              Get.find<DashboardRepositoryImpl>()))
      ..lazyPut<DashboardController>(
        () => DashboardController(
          getDashboard: Get.find(),
          getDetailLateUsecase: Get.find(),
          getDetailPermitRequestUsecase: Get.find(),
          getDetailSpecialLeaveRequestUsecase: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
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
      ..lazyPut<ActionFormLeaveUsecase>(
        () => ActionFormLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
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
          actionFormLeaveUsecase: Get.find<ActionFormLeaveUsecase>(),
          getCacheUserUsecase: Get.find<GetCacheUserUsecase>(),
          createFormPermitUsecase: Get.find<CreateFormPermitUsecase>(),
        ),
      )

      // Payroll
      ..lazyPut<PayrollRemoteDataSourcesImpl>(
        () => PayrollRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<PayrollPeriodRepositoryImpl>(
        () => PayrollPeriodRepositoryImpl(
          remoteData: Get.find<PayrollRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut<GetPayrollPeriodeUsecase>(
        () => GetPayrollPeriodeUsecase(
          Get.find<PayrollPeriodRepositoryImpl>(),
        ),
      )
      ..lazyPut<PayrollDownloadUrlUsecase>(
        () => PayrollDownloadUrlUsecase(
          Get.find<PayrollPeriodRepositoryImpl>(),
        ),
      )
      ..lazyPut<PayrollDataOverviewUsecase>(
        () => PayrollDataOverviewUsecase(
          Get.find<PayrollPeriodRepositoryImpl>(),
        ),
      )
      ..lazyPut<PayrollController>(
        () => PayrollController(
          payrollDataOverviewUsecase: Get.find<PayrollDataOverviewUsecase>(),
          payrollDownloadUrlUsecase: Get.find<PayrollDownloadUrlUsecase>(),
          getPayrollPeriodeUsecase: Get.find<GetPayrollPeriodeUsecase>(),
          downloadFile: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      );
  }
}
