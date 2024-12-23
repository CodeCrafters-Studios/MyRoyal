import 'package:get/get.dart';
import 'package:iroyal/app/modules/approval/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/approval/data/repositories/approval_repository_impl.dart';
import 'package:iroyal/app/modules/approval/domain/usecases/get_leave_approval_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/data/datasources/remote_datasource.dart';
import 'package:iroyal/app/modules/leave_summary/data/repositories/leave_repository_impl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/cancel_form_leave_usecase.dart';

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
      ..lazyPut<CancelFormLeaveUsecase>(
        () => CancelFormLeaveUsecase(
          Get.find<LeaveRepositoryImpl>(),
        ),
      )
      ..lazyPut<ApprovalController>(
        () => ApprovalController(
          cancelFormLeaveUsecase: Get.find(),
          getLeaveApprovalUsecase: Get.find(),
        ),
      );
  }
}
