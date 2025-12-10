import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/approval/domain/entities/approval_entity.dart';
import 'package:iroyal/app/modules/approval/domain/usecases/get_leave_approval_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/action_form_leave_params_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/action_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/action_form_leave_usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class ApprovalController extends GetxController {
  ApprovalController({
    required this.getLeaveApprovalUsecase,
    required this.actionFormLeaveUsecase,
    required this.appDialog,
  });

  final GetLeaveApprovalUsecase getLeaveApprovalUsecase;
  final ActionFormLeaveUsecase actionFormLeaveUsecase;
  final AppDialog appDialog;

  TextEditingController search = TextEditingController();

  RxBool isLoading = false.obs;

  RxString valueListener = ''.obs;
  RxString reasonText = ''.obs;

  RxList<ApprovalEntity> listLeaveApprovalRes = <ApprovalEntity>[].obs;
  RxList<ApprovalEntity> filterApprovalLeaveData = <ApprovalEntity>[].obs;

  Rx<ActionFormLeaveEntity> actionFormRes =
      const ActionFormLeaveEntity(id: 0, codeNo: '').obs;

  @override
  void onInit() {
    _getLeaveApprovalSummary();
    super.onInit();
  }

  Future<void> onRefresh() async {
    filterApprovalLeaveData.value = [];
    listLeaveApprovalRes.value = [];
    _getLeaveApprovalSummary();
  }

  Future<void> _getLeaveApprovalSummary() async {
    isLoading.value = true;

    final r = await getLeaveApprovalUsecase();

    r.fold((l) {
      isLoading.value = false;
    }, (r) {
      listLeaveApprovalRes.value = r;
      filterApprovalLeaveData.value = listLeaveApprovalRes;
      isLoading.value = false;
    });
  }

  void onChanged(String value) {
    valueListener.value = value;
    _filterApprovalLeaveData(
        value, listLeaveApprovalRes, filterApprovalLeaveData);
  }

  void clear() {
    search.clear();
    valueListener.value = '';
    filterApprovalLeaveData.value = listLeaveApprovalRes;
  }

  void _filterApprovalLeaveData(String value, RxList<ApprovalEntity> data,
      RxList<ApprovalEntity> filterApprovalLeaveData) {
    if (value.isEmpty) {
      filterApprovalLeaveData.value = data;
      AppUtils.logApp('${filterApprovalLeaveData.length}');
    } else {
      filterApprovalLeaveData.value = data
          .where((e) =>
              e.fullName.toLowerCase().contains(value.toLowerCase()) ||
              e.codeNo.toLowerCase().contains(value.toLowerCase()) ||
              e.periode.start
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.periode.end
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()) ||
              e.status.toString().toLowerCase().contains(value.toLowerCase()))
          .toList();
      AppUtils.logApp('${filterApprovalLeaveData.length}');
    }
  }

  Future<void> actionFormLeave(String codeNo, String type, int level,
      String reasonRejected, String typeSubmission) async {
    isLoading.value = true;

    final r = await actionFormLeaveUsecase(
      ActionFormLeaveParamsModel(
        type: type,
        level: level,
        codeNo: codeNo,
        feedback: reasonRejected,
        typeSubmission: typeSubmission,
      ),
    );

    r.fold(
      (l) {
        isLoading(false);
        reasonText.value = '';
      },
      (r) {
        isLoading(false);
        reasonText.value = '';
        _getLeaveApprovalSummary();
        actionFormRes.value = r;
        AppDialogImpl().showCustomInfoDialog(
          title: type == 'approved'
              ? 'Your Approval has been updated!'
              : 'Request Successfully rejected!',
          textButton: 'Done',
          imagePath: type == 'approved'
              ? 'assets/json/lottie_success_approve.json'
              : 'assets/json/lottie_success_reject.json',
          height: 200.h,
        );
      },
    );
  }
}
