import 'package:get/get.dart';

import '../modules/approval/presentation/bindings/approval_binding.dart';
import '../modules/approval/presentation/views/approval_view.dart';
import '../modules/articles/presentation/bindings/articles_binding.dart';
import '../modules/articles/presentation/views/articles_view.dart';
import '../modules/attendance/presentation/bindings/attendance_binding.dart';
import '../modules/attendance/presentation/views/attendance_view.dart';
import '../modules/bottomnavbar/presentation/bindings/bottomnavbar_binding.dart';
import '../modules/bottomnavbar/presentation/views/bottomnavbar_view.dart';
import '../modules/change_password/bindings/change_password_binding.dart';
import '../modules/change_password/views/change_password_view.dart';
import '../modules/change_pin/bindings/change_pin_binding.dart';
import '../modules/change_pin/views/change_pin_view.dart';
import '../modules/check_password/presentation/bindings/check_password_binding.dart';
import '../modules/check_password/presentation/views/check_password_view.dart';
import '../modules/dashboard/presentation/bindings/dashboard_binding.dart';
import '../modules/dashboard/presentation/views/dashboard_view.dart';
import '../modules/detail_tasks/bindings/detail_tasks_binding.dart';
import '../modules/detail_tasks/views/detail_tasks_view.dart';
import '../modules/detail_tracking_document/presentation/bindings/detail_tracking_document_binding.dart';
import '../modules/detail_tracking_document/presentation/views/detail_tracking_document_view.dart';
import '../modules/edit_profile/presentation/bindings/edit_profile_binding.dart';
import '../modules/edit_profile/presentation/views/edit_profile_view.dart';
import '../modules/help_and_support/bindings/help_and_support_binding.dart';
import '../modules/help_and_support/views/help_and_support_view.dart';
import '../modules/home/presentation/bindings/home_binding.dart';
import '../modules/home/presentation/views/home_view.dart';
import '../modules/leave_summary/presentation/bindings/leave_summary_binding.dart';
import '../modules/leave_summary/presentation/views/leave_summary_view.dart';
import '../modules/leave_summary/presentation/views/leaves_request_view.dart';
import '../modules/login/presentation/bindings/login_binding.dart';
import '../modules/login/presentation/views/login_view.dart';
import '../modules/my_assets/bindings/my_assets_binding.dart';
import '../modules/my_assets/views/my_assets_view.dart';
import '../modules/my_teams/presentation/bindings/my_teams_binding.dart';
import '../modules/my_teams/presentation/views/my_teams_view.dart';
import '../modules/notifications/presentation/bindings/notifications_binding.dart';
import '../modules/notifications/presentation/views/notifications_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/online_app/cam/cam_app/presentation/bindings/cam_app_binding.dart';
import '../modules/online_app/cam/cam_app/presentation/views/cam_app_view.dart';
import '../modules/online_app/cam/cam_app_release_order/presentation/bindings/cam_app_release_order_binding.dart';
import '../modules/online_app/cam/cam_app_release_order/presentation/views/cam_app_release_order_view.dart';
import '../modules/online_app/cam/cam_app_reserved_by/presentation/bindings/cam_app_reserved_by_binding.dart';
import '../modules/online_app/cam/cam_app_reserved_by/presentation/views/cam_app_reserved_by_view.dart';
import '../modules/online_app/cam/cam_app_trace_serial/presentation/bindings/cam_app_trace_serial_binding.dart';
import '../modules/online_app/cam/cam_app_trace_serial/presentation/views/cam_app_trace_serial_view.dart';
import '../modules/online_app/ras/ras_app/bindings/ras_app_binding.dart';
import '../modules/online_app/ras/ras_app/views/ras_app_view.dart';
import '../modules/online_app/ras/ras_app_release_order/bindings/ras_app_release_order_binding.dart';
import '../modules/online_app/ras/ras_app_release_order/views/ras_app_release_order_view.dart';
import '../modules/online_app/ras/ras_app_reserved_by/bindings/ras_app_reserved_by_binding.dart';
import '../modules/online_app/ras/ras_app_reserved_by/views/ras_app_reserved_by_view.dart';
import '../modules/online_app/ras/ras_app_trace_serial/bindings/ras_app_trace_serial_binding.dart';
import '../modules/online_app/ras/ras_app_trace_serial/views/ras_app_trace_serial_view.dart';
import '../modules/payroll/presentation/bindings/payroll_binding.dart';
import '../modules/payroll/presentation/views/payroll_view.dart';
import '../modules/pin/bindings/pin_binding.dart';
import '../modules/pin/views/pin_view.dart';
import '../modules/profile/presentation/bindings/profile_binding.dart';
import '../modules/profile/presentation/views/profile_view.dart';
import '../modules/settings/presentation/bindings/settings_binding.dart';
import '../modules/settings/presentation/views/settings_view.dart';
import '../modules/splash/bindings/splash_binding.dart';
import '../modules/splash/views/splash_view.dart';
import '../modules/tasks/presentation/bindings/tasks_binding.dart';
import '../modules/tasks/presentation/views/tasks_view.dart';
import '../modules/terms_and_policies/bindings/terms_and_policies_binding.dart';
import '../modules/terms_and_policies/views/terms_and_policies_view.dart';
import '../modules/tracking_document/presentation/bindings/tracking_document_binding.dart';
import '../modules/tracking_document/presentation/views/tracking_document_view.dart';
import '../modules/validation_selfie/bindings/validation_selfie_binding.dart';
import '../modules/validation_selfie/views/validation_selfie_view.dart';
import '../modules/visit/presentation/bindings/visit_binding.dart';
import '../modules/visit/presentation/views/visit_view.dart';
import '../modules/webtel/presentation/bindings/webtel_binding.dart';
import '../modules/webtel/presentation/views/webtel_view.dart';

// ignore_for_file: constant_identifier_names

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.BOTTOMNAVBAR,
      page: () => const BottomnavbarView(),
      binding: BottomnavbarBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.MY_TEAMS,
      page: () => const MyTeamsView(),
      binding: MyTeamsBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.WEBTEL,
      page: () => const WebtelView(),
      binding: WebtelBinding(),
    ),
    GetPage(
      name: _Paths.TRACKING_DOCUMENT,
      page: () => const TrackingDocumentView(),
      binding: TrackingDocumentBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TRACKING_DOCUMENT,
      page: () => const DetailTrackingDocumentView(),
      binding: DetailTrackingDocumentBinding(),
    ),
    GetPage(
      name: _Paths.TASKS,
      page: () => const TasksView(),
      binding: TasksBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_TASKS,
      page: () => const DetailTasksView(),
      binding: DetailTasksBinding(),
    ),
    GetPage(
      name: _Paths.NOTIFICATIONS,
      page: () => const NotificationsView(),
      binding: NotificationsBinding(),
    ),
    GetPage(
      name: _Paths.HELP_AND_SUPPORT,
      page: () => const HelpAndSupportView(),
      binding: HelpAndSupportBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE,
      page: () => AttendanceView(),
      binding: AttendanceBinding(),
    ),
    GetPage(
      name: _Paths.LEAVE_SUMMARY,
      page: () => const LeaveSummaryView(),
      binding: LeaveSummaryBinding(),
    ),
    GetPage(
      name: _Paths.PAYROLL,
      page: () => const PayrollView(),
      binding: PayrollBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: _Paths.VISIT,
      page: () => const VisitView(),
      binding: VisitBinding(),
    ),
    GetPage(
      name: _Paths.PIN,
      page: () => const PinView(),
      binding: PinBinding(),
    ),
    GetPage(
      name: _Paths.TERMS_AND_POLICIES,
      page: () => TermsAndPoliciesView(),
      binding: TermsAndPoliciesBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PASSWORD,
      page: () => const ChangePasswordView(),
      binding: ChangePasswordBinding(),
    ),
    GetPage(
      name: _Paths.CHANGE_PIN,
      page: () => const ChangePinView(),
      binding: ChangePinBinding(),
    ),
    GetPage(
      name: _Paths.EDIT_PROFILE,
      page: () => const EditProfileView(),
      binding: EditProfileBinding(),
    ),
    GetPage(
      name: _Paths.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: _Paths.LEAVES,
      page: () => const LeavesRequestView(),
      binding: LeaveSummaryBinding(),
    ),
    GetPage(
      name: _Paths.APPROVAL,
      page: () => const ApprovalView(),
      binding: ApprovalBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_PASSWORD,
      page: () => const CheckPasswordView(),
      binding: CheckPasswordBinding(),
    ),
    GetPage(
      name: _Paths.ARTICLES,
      page: () => const ArticlesView(),
      binding: ArticlesBinding(),
    ),
    GetPage(
      name: _Paths.CAM_APP,
      page: () => const CamAppView(),
      binding: CamAppBinding(),
    ),
    GetPage(
      name: _Paths.CAM_APP_TRACE_SERIAL,
      page: () => const CamAppTraceSerialView(),
      binding: CamAppTraceSerialBinding(),
    ),
    GetPage(
      name: _Paths.CAM_APP_RESERVED_BY,
      page: () => const CamAppReservedByView(),
      binding: CamAppReservedByBinding(),
    ),
    GetPage(
      name: _Paths.CAM_APP_RELEASE_ORDER,
      page: () => const CamAppReleaseOrderView(),
      binding: CamAppReleaseOrderBinding(),
    ),
    GetPage(
      name: _Paths.MY_ASSETS,
      page: () => const MyAssetsView(),
      binding: MyAssetsBinding(),
    ),
    GetPage(
      name: _Paths.RAS_APP,
      page: () => const RasAppView(),
      binding: RasAppBinding(),
    ),
    GetPage(
      name: _Paths.RAS_APP_RELEASE_ORDER,
      page: () => const RasAppReleaseOrderView(),
      binding: RasAppReleaseOrderBinding(),
    ),
    GetPage(
      name: _Paths.RAS_APP_RESERVED_BY,
      page: () => const RasAppReservedByView(),
      binding: RasAppReservedByBinding(),
    ),
    GetPage(
      name: _Paths.RAS_APP_TRACE_SERIAL,
      page: () => const RasAppTraceSerialView(),
      binding: RasAppTraceSerialBinding(),
    ),
    GetPage(
      name: _Paths.VALIDATION_SELFIE,
      page: () => const ValidationSelfieView(),
      binding: ValidationSelfieBinding(),
    ),
  ];
}
