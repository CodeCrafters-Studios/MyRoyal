import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/repositories/home_repository_impl.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/action_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';
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
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // Home
      ..lazyPut(
        () => GetCacheUserUsecase(
          Get.find<HomeRepositoryImpl>(),
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
      );
  }
}
