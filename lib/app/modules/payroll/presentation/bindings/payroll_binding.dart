import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/payroll/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/payroll/data/repositories/payroll_period_repository_impl.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/get_payroll_periode_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_data_overview_usecase.dart';
import 'package:MyRoyal/app/modules/payroll/domain/usecases/payroll_download_url_usecase.dart';
import 'package:MyRoyal/app/modules/profile/data/datasources/local_data.dart';
import 'package:MyRoyal/app/modules/profile/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/profile/data/repositories/profile_repository_impl.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/download_file.dart';
import 'package:MyRoyal/app/modules/profile/domain/usecases/get_profile.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/permission/app_permission.dart';

import '../controllers/payroll_controller.dart';

class PayrollBinding extends Bindings {
  @override
  void dependencies() {
    Get
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
          getPayrollPeriodeUsecase: Get.find<GetPayrollPeriodeUsecase>(),
          payrollDownloadUrlUsecase: Get.find<PayrollDownloadUrlUsecase>(),
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
