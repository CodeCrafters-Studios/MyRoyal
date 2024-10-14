import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/repositories/user_repository_impl.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/cancel_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_approval_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';

import '../controllers/leave_summary_controller.dart';

class LeaveSummaryBinding extends Bindings {
  @override
  void dependencies() {
    Get
      // Home
      ..lazyPut(
        () => GetCacheUser(
          Get.find<HomeRepositoryImpl>(),
        ),
      )

      // Leave Summary
      ..lazyPut<GetSubtituteEmployeeUsecase>(
        () => GetSubtituteEmployeeUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<CreateFormLeaveUsecase>(
        () => CreateFormLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<CancelFormLeaveUsecase>(
        () => CancelFormLeaveUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<GetLeaveApprovalUsecase>(
        () => GetLeaveApprovalUsecase(Get.find<LeaveRepositoryImpl>()),
      )
      ..lazyPut<LeaveSummaryController>(
        () => LeaveSummaryController(
          getLeaveUsecase: Get.find<GetLeaveUsecase>(),
          getSubtituteEmployeeUsecase: Get.find<GetSubtituteEmployeeUsecase>(),
          createFormLeaveUsecase: Get.find<CreateFormLeaveUsecase>(),
          cancelFormLeaveUsecase: Get.find<CancelFormLeaveUsecase>(),
          getLeaveApprovalUsecase: Get.find<GetLeaveApprovalUsecase>(),
          getCacheUser: Get.find<GetCacheUser>(),
        ),
      );
  }
}
