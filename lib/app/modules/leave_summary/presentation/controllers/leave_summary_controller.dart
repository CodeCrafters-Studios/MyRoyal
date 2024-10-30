import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/data_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_data_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/leave_approval_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/cancel_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_approval_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_subtitute_employee_usecase.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class LeaveSummaryController extends GetxController {
  LeaveSummaryController({
    required this.getLeaveUsecase,
    required this.getSubtituteEmployeeUsecase,
    required this.createFormLeaveUsecase,
    required this.cancelFormLeaveUsecase,
    required this.getLeaveApprovalUsecase,
    required this.getCacheUser,
  });

  late final TabController tabController;
  TextEditingController search = TextEditingController();

  final config = CalendarDatePicker2Config(
    firstDate: DateTime.now().add(const Duration(days: 3)),
    dayModeScrollDirection: Axis.horizontal,
    calendarType: CalendarDatePicker2Type.multi,
    selectedDayHighlightColor: Colors.indigo,
    dayTextStyle: TS.bodySmall,
    monthTextStyle: TS.bodySmall,
    yearTextStyle: TS.bodySmall,
    nextMonthIcon: const Icon(
      size: 15,
      Icons.arrow_forward_ios_rounded,
      color: primary,
    ),
    lastMonthIcon: const Icon(
      size: 15,
      Icons.arrow_back_ios_new_rounded,
      color: primary,
    ),
    selectedYearTextStyle: TS.bodyLarge,
  );

  RxBool isCasual = false.obs;
  RxBool isSick = false.obs;
  RxBool isLoading = false.obs;

  RxString selectedStartDate = 'Select date'.obs;
  RxString selectedSubtituteEmployee = ''.obs;
  RxString reason = ''.obs;
  RxString reasonText = ''.obs;
  RxString valueListener = ''.obs;

  RxInt selectedSubtituteEmployeeId = 0.obs;

  Rx<LeaveModel> leaveModelRes =
      LeaveModel(code: 0, message: '', data: LeaveDataModel.empty()).obs;
  Rx<CreateFormLeaveEntity> createFormRes =
      const CreateFormLeaveEntity(id: 0, codeNo: '').obs;
  Rx<CancelFormLeaveEntity> cancelFormRes =
      const CancelFormLeaveEntity(id: 0, codeNo: '').obs;
  final Rx<UserDataModel> userData = UserDataModel.empty().obs;

  RxList<DataLeaveModel> leaveData = <DataLeaveModel>[].obs;
  RxList<DataLeaveModel> filterLeaveData = <DataLeaveModel>[].obs;
  RxList<Employee> subtituteEmployeeListRes = <Employee>[].obs;
  RxList<DateTime> multiDatePickerValueWithDefaultValue = <DateTime>[].obs;
  RxList<LeaveApprovalEntity> listLeaveApprovalRes =
      <LeaveApprovalEntity>[].obs;
  RxList<LeaveApprovalEntity> filterApprovalLeaveData =
      <LeaveApprovalEntity>[].obs;

  final GetLeaveUsecase getLeaveUsecase;
  final GetSubtituteEmployeeUsecase getSubtituteEmployeeUsecase;
  final CreateFormLeaveUsecase createFormLeaveUsecase;
  final CancelFormLeaveUsecase cancelFormLeaveUsecase;
  final GetLeaveApprovalUsecase getLeaveApprovalUsecase;
  final GetCacheUser getCacheUser;

  @override
  void onInit() async {
    tabController = TabController(length: 2, vsync: TicckerProvider());
    await _getCacheUser();
    _getLeaveSummary();
    _getLeaveApprovalSummary();
    _getSubtituteEmployees();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    filterApprovalLeaveData.value = [];
    listLeaveApprovalRes.value = [];
    filterLeaveData.value = [];
    leaveData.value = [];

    await _getCacheUser();
    _getLeaveSummary();
    _getLeaveApprovalSummary();
    _getSubtituteEmployees();
  }

  void selectCasualType() {
    isCasual.value = true;
    isSick.value = false;
  }

  void selectSickType() {
    isSick.value = true;
    isCasual.value = false;
  }

  Future<void> _getCacheUser() async {
    isLoading.value = true;
    final r = await getCacheUser();
    r.fold((l) {
      isLoading.value = false;
      AppUtils.logApp(l.toString());
    }, (r) {
      isLoading.value = false;
      AppUtils.logApp('RESPONSE CACHE USER :::: $r');
      userData.value = r;
    });
  }

  Future<void> _getLeaveSummary() async {
    isLoading.value = true;

    final r = await getLeaveUsecase();

    r.fold((l) {
      isLoading.value = false;
      AppUtils.logApp(l.toString());
    }, (r) {
      leaveModelRes.value = r;
      leaveData.value = leaveModelRes().data!.dataLeave!;
      filterLeaveData.value = leaveData;
      isLoading.value = false;
    });
  }

  Future<void> _getLeaveApprovalSummary() async {
    isLoading.value = true;

    final r = await getLeaveApprovalUsecase();

    r.fold((l) {
      isLoading.value = false;
      AppUtils.logApp(l.toString());
    }, (r) {
      listLeaveApprovalRes.value = r;
      filterApprovalLeaveData.value = listLeaveApprovalRes;
      isLoading.value = false;
    });
  }

  Future<void> _getSubtituteEmployees() async {
    isLoading.value = true;

    final r = await getSubtituteEmployeeUsecase();

    r.fold((l) {
      isLoading.value = false;
      AppUtils.logApp(l.toString());
    }, (r) {
      isLoading.value = false;
      subtituteEmployeeListRes.value = r.employees;
      AppUtils.logApp('$subtituteEmployeeListRes');
    });
  }

  void setSubtituteEmployee(String value, int id) {
    selectedSubtituteEmployee.value = value;
    selectedSubtituteEmployeeId.value = id;
  }

  void clearSubtituteEmployee() {
    selectedSubtituteEmployee.value = '';
  }

  Future<void> createFormLeave() async {
    AppUtils.logApp(selectedSubtituteEmployee.value);
    AppUtils.logApp(selectedSubtituteEmployeeId.value.toString());
    AppUtils.logApp(reason.value);

    final List<DateTime> dataLeaveList = multiDatePickerValueWithDefaultValue;

    final List<String> formattedDates =
        dataLeaveList.map((date) => date.toIso8601String()).toList();

    AppUtils.logApp('$formattedDates');

    isLoading.value = true;

    final r = await createFormLeaveUsecase(
      CreateFormLeaveParamsEntity(
        dateLeave: formattedDates,
        reason: reason.value,
        substituteId: selectedSubtituteEmployeeId.value,
      ),
    );

    r.fold((l) {
      isLoading(false);
      final m = l.properties[0] as ApiException;
      AppUtils.logApp('${m.message}');
    }, (r) {
      isLoading(false);
      createFormRes.value = r;
      multiDatePickerValueWithDefaultValue.value = [];
      selectedSubtituteEmployee.value = '';
      selectedSubtituteEmployeeId.value = 0;
      reason.value = '';
      Get.back();
      AppDialogImpl()
          .showSuccessSnackBar(description: 'Success Create Form Leave');
      _getLeaveSummary();
    });
  }

  Future<void> cancelFormLeave(String codeNo) async {
    isLoading.value = true;

    final r = await cancelFormLeaveUsecase(
      CancelFormLeaveParamsEntity(
        type: 'canceled',
        level: 0,
        codeNo: codeNo,
        feedback: '',
      ),
    );

    r.fold((l) {
      Get.back();
      isLoading(false);
      final m = l.properties[0] as ApiException;
      AppDialogImpl().showErrorDialog(description: m.message);
    }, (r) {
      Get.back();
      isLoading(false);
      _getLeaveSummary();
      cancelFormRes.value = r;
      AppDialogImpl().showSuccessSnackBar(description: 'Form Leave Canceled');
    });
  }

  void onChanged(String value) {
    valueListener.value = value;
    _filterLeaveData(value, leaveData, filterLeaveData);
    _filterApprovalLeaveData(
        value, listLeaveApprovalRes, filterApprovalLeaveData);
  }

  void clear() {
    search.clear();
    valueListener.value = '';
    filterLeaveData.value = leaveData;
    filterApprovalLeaveData.value = listLeaveApprovalRes;
  }

  void _filterLeaveData(String value, RxList<DataLeaveModel> data,
      RxList<DataLeaveModel> filterData) {
    if (value.isEmpty) {
      filterData.value = data;
      AppUtils.logApp('${filterData.length}');
    } else {
      filterData.value = data
          .where((e) =>
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
      AppUtils.logApp('${filterData.length}');
    }
  }

  void _filterApprovalLeaveData(String value, RxList<LeaveApprovalEntity> data,
      RxList<LeaveApprovalEntity> filterApprovalLeaveData) {
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

  Future<void> actionFormLeave(
      String codeNo, String type, int level, String reasonRejected) async {
    isLoading.value = true;

    final r = await cancelFormLeaveUsecase(
      CancelFormLeaveParamsEntity(
        type: type,
        level: level,
        codeNo: codeNo,
        feedback: reasonRejected,
      ),
    );

    r.fold((l) {
      Get.back();
      isLoading(false);
      reasonText.value = '';
      final m = l.properties[0] as ApiException;
      AppDialogImpl().showErrorDialog(description: m.message);
    }, (r) {
      Get.back();
      isLoading(false);
      reasonText.value = '';
      _getLeaveApprovalSummary();
      cancelFormRes.value = r;
      AppDialogImpl().showSuccessSnackBar(
          description: 'Form Leave ${type.capitalizeFirst}');
    });
  }
}
