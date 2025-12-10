import 'package:get/get.dart';
import 'package:iroyal/app/modules/dashboard/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_detail_late_usecase.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_detail_permit_request_usecase.dart';
import 'package:iroyal/app/modules/dashboard/domain/usecases/get_detail_special_leave_request_usecase.dart';
import 'package:iroyal/app/modules/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/app/modules/help_and_support/controllers/help_and_support_controller.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/action_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/notifications/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/notifications/data/repositories/notification_repository_impl.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/tap_notification.dart';
import 'package:iroyal/app/modules/notifications/presentation/controllers/notifications_controller.dart';
import 'package:iroyal/app/modules/payroll/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/payroll/data/repositories/payroll_period_repository_impl.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:iroyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:iroyal/app/modules/payroll/presentation/controllers/payroll_controller.dart';
import 'package:iroyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:iroyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:iroyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:iroyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tracking_document/data/datasources/remote_data.dart';
import 'package:iroyal/app/modules/tracking_document/data/repositories/tracking_document_repositories_impl.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document_history.dart';
import 'package:iroyal/app/modules/tracking_document/domain/usecase/get_tracking_document_on_progress.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // My Teams
      // ..lazyPut<MyTeamsController>(
      //   () => MyTeamsController(
      //     getMyTeams: Get.find(),
      //     getUser: Get.find(),
      //   ),
      // )
      // ..lazyPut<MyTeamsRemoteDataSourcesImpl>(
      //   () => MyTeamsRemoteDataSourcesImpl(
      //     httpService: Get.find(),
      //   ),
      // )
      // ..lazyPut<MyTeamsRepositoryImpl>(
      //   () => MyTeamsRepositoryImpl(
      //     remoteData: Get.find<MyTeamsRemoteDataSourcesImpl>(),
      //   ),
      // )
      // ..lazyPut(
      //   () => GetMyTeams(
      //     Get.find<MyTeamsRepositoryImpl>(),
      //   ),
      // )

      // Tracking Document
      ..lazyPut<TrackingDocumentController>(
        () => TrackingDocumentController(
          getTrackingDocumentOnProgress: Get.find(),
          getTrackingDocumentHistory: Get.find(),
          appDialog: Get.find<AppDialogImpl>(),
        ),
      )
      ..lazyPut<TrackingDocumentRemoteDataSourcesImpl>(
        () => TrackingDocumentRemoteDataSourcesImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<TrackingDocumentRepositoriesImpl>(
        () => TrackingDocumentRepositoriesImpl(
          remoteData: Get.find<TrackingDocumentRemoteDataSourcesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetTrackingDocumentOnProgress(
          Get.find<TrackingDocumentRepositoriesImpl>(),
        ),
      )
      ..lazyPut(
        () => GetTrackingDocumentHistory(
          Get.find<TrackingDocumentRepositoriesImpl>(),
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
            appDialog: Get.find<AppDialogImpl>()),
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
          getCacheUser: Get.find<GetCacheUser>(),
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
