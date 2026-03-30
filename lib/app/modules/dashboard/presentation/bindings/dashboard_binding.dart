import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/dashboard/data/datasources/remote_datasource.dart';
import 'package:MyRoyal/app/modules/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_dashboard_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_late_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_permit_request_usecase.dart';
import 'package:MyRoyal/app/modules/dashboard/domain/usecases/get_detail_special_leave_request_usecase.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get
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
      );
  }
}
