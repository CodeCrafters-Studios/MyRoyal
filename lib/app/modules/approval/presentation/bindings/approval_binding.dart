import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/approval/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/approval/data/repositories/approval_repository_impl.dart';
import 'package:MyRoyal/app/modules/approval/domain/usecases/get_leave_approval_usecase.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/datasources/remote_data.dart';
import 'package:MyRoyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/usecases/action_form_leave_usecase.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';

import '../controllers/approval_controller.dart';

class ApprovalBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<ApprovalRemoteDataSourceImpl>(
        () => ApprovalRemoteDataSourceImpl(
          httpService: Get.find(),
        ),
      )
      ..lazyPut<LeaveRemoteDataSourcesImpl>(
        () => LeaveRemoteDataSourcesImpl(httpService: Get.find()),
      )
      ..lazyPut<ApprovalRepositoryImpl>(
        () => ApprovalRepositoryImpl(
          remoteData: Get.find<ApprovalRemoteDataSourceImpl>(),
        ),
      )
      ..lazyPut<LeaveRepositoryImpl>(
        () => LeaveRepositoryImpl(
            remoteData: Get.find<LeaveRemoteDataSourcesImpl>()),
      )
      ..lazyPut<GetLeaveApprovalUsecase>(
        () => GetLeaveApprovalUsecase(
          Get.find<ApprovalRepositoryImpl>(),
        ),
      )
      ..lazyPut<ActionFormLeaveUsecase>(
        () => ActionFormLeaveUsecase(
          Get.find<LeaveRepositoryImpl>(),
        ),
      )
      ..lazyPut<ApprovalController>(
        () => ApprovalController(
            actionFormLeaveUsecase: Get.find(),
            getLeaveApprovalUsecase: Get.find(),
            appDialog: Get.find<AppDialogImpl>()),
      );
  }
}
