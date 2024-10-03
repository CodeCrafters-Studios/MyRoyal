import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get
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
      ..lazyPut<LeaveSummaryController>(
        () => LeaveSummaryController(
            getLeaveUsecase: Get.find<GetLeaveUsecase>()),
      );
  }
}
