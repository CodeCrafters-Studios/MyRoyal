import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/data/models/user_data.dart';
import 'package:iroyal/app/modules/home/domain/usecases/get_cache_user.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/data_leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_data_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/leave_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/permit_data_model.dart';
import 'package:iroyal/app/modules/leave_summary/data/models/permit_model.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/cancel_form_leave_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_leave_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/create_form_permit_params_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/permit_type_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/cancel_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/create_form_permit_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_leave_usecase.dart';
import 'package:iroyal/app/modules/leave_summary/domain/usecases/get_permit_usecase.dart';
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
    required this.getPermitUsecase,
    required this.getSubtituteEmployeeUsecase,
    required this.createFormLeaveUsecase,
    required this.cancelFormLeaveUsecase,
    required this.getCacheUser,
    required this.createFormPermitUsecase,
  });

  late final TabController tabLeaveController;
  late final TabController tabPermitController;
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
  RxString reasonPermit = ''.obs;
  RxString valueListener = ''.obs;
  RxString valueListenerPermit = ''.obs;
  RxString selectedPermitType = ''.obs;
  RxString selectedPermitTypeCode = ''.obs;
  RxString selectedStartTimePermitFormatted = ''.obs;
  RxString selectedEndTimePermitFormatted = ''.obs;

  Rx<TimeOfDay> selectedStartTime = TimeOfDay(hour: 0, minute: 0).obs;
  Rx<TimeOfDay> selectedEndTime = TimeOfDay(hour: 0, minute: 0).obs;

  Rx<DateTime> selectedStartDatePermit = DateTime(0).obs;
  Rx<DateTime> selectedEndDatePermit = DateTime(0).obs;

  RxInt selectedSubtituteEmployeeId = 0.obs;
  RxInt currentTabIndex = 0.obs;

  Rx<LeaveModel> leaveModelRes =
      LeaveModel(code: 0, message: '', data: LeaveDataModel.empty()).obs;
  Rx<PermitModel> permitModelRes = PermitModel(
    code: 0,
    message: '',
    data: [],
  ).obs;
  Rx<CreateFormLeaveEntity> createFormRes =
      const CreateFormLeaveEntity(id: 0, codeNo: '').obs;
  Rx<CancelFormLeaveEntity> cancelFormRes =
      const CancelFormLeaveEntity(id: 0, codeNo: '').obs;
  final Rx<UserDataModel> userData = UserDataModel.empty().obs;

  RxList<DataLeaveModel> leaveData = <DataLeaveModel>[].obs;
  RxList<PermitDataModel> permitData = <PermitDataModel>[].obs;
  RxList<DataLeaveModel> filterLeaveData = <DataLeaveModel>[].obs;
  RxList<PermitDataModel> filterPermitData = <PermitDataModel>[].obs;
  RxList<Employee> subtituteEmployeeListRes = <Employee>[].obs;
  RxList<DateTime> multiDatePickerValueleaveRequestWithDefaultValue =
      <DateTime>[].obs;
  List<PermitTypeEntity> permitTypeList = <PermitTypeEntity>[
    PermitTypeEntity(
      type: 'Late-in leave permit',
      typeCode: 'HD',
      typeTranslate: 'Izin masuk siang',
    ),
    PermitTypeEntity(
      type: 'Early leave permit request',
      typeCode: 'PC',
      typeTranslate: 'Izin pulang cepat',
    ),
    PermitTypeEntity(
      type: 'Permit request',
      typeCode: 'GS',
      typeTranslate: 'Izin',
    ),
    PermitTypeEntity(
      type: 'Alpha or no reason',
      typeCode: 'TK',
      typeTranslate: 'Tanpa keterangan (alpa)',
    ),
    PermitTypeEntity(
      type: 'Cut Leave',
      typeCode: 'CUT_LEAVE',
      typeTranslate: 'Izin potong cuti',
    ),
  ];

  final GetLeaveUsecase getLeaveUsecase;
  final GetPermitUsecase getPermitUsecase;
  final GetSubtituteEmployeeUsecase getSubtituteEmployeeUsecase;
  final CreateFormLeaveUsecase createFormLeaveUsecase;
  final CancelFormLeaveUsecase cancelFormLeaveUsecase;
  final GetCacheUser getCacheUser;
  final CreateFormPermitUsecase createFormPermitUsecase;

  @override
  void onInit() async {
    tabLeaveController = TabController(length: 2, vsync: TicckerProvider());
    tabPermitController = TabController(length: 2, vsync: TicckerProvider());
    await _getCacheUser();
    _getLeaveSummary();
    _getPermitSummary();
    _getSubtituteEmployees();
    super.onInit();
  }

  @override
  void onClose() {
    tabLeaveController.dispose();
    tabPermitController.dispose();
    super.onClose();
  }

  Future<void> onRefresh() async {
    leaveData.value = [];
    permitData.value = [];
    filterLeaveData.value = [];
    filterPermitData.value = [];

    await _getCacheUser();
    _getLeaveSummary();
    _getPermitSummary();
    _getSubtituteEmployees();
  }

  bool isTabSelected(int index) {
    AppUtils.logApp("Current Index $index");
    return currentTabIndex.value == index;
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

    r.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp(l.toString());
      },
      (r) {
        leaveModelRes.value = r;
        leaveData.value = leaveModelRes().data!.dataLeave!;
        filterLeaveData.value = leaveData;
        isLoading.value = false;
      },
    );
  }

  Future<void> _getPermitSummary() async {
    isLoading.value = true;

    final r = await getPermitUsecase();

    r.fold(
      (l) {
        isLoading.value = false;
        AppUtils.logApp(l.toString());
      },
      (r) {
        permitModelRes.value = r;
        permitData.value = permitModelRes().data;
        AppUtils.logApp('PERMIT DATA ::: ${permitData.length}');
        filterPermitData.value = permitData;
        isLoading.value = false;
      },
    );
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

  void setPermitType(String value, String typeCode) {
    selectedPermitType.value = value;
    selectedPermitTypeCode.value = typeCode;
    AppUtils.logApp(selectedPermitType.value);
    AppUtils.logApp(selectedPermitTypeCode.value);
  }

  void clearSubtituteEmployee() {
    selectedSubtituteEmployeeId.value = 0;
    selectedSubtituteEmployee.value = '';
  }

  void clearPermitType() {
    selectedPermitType.value = '';
  }

  Future<void> createFormLeave() async {
    AppUtils.logApp(selectedSubtituteEmployee.value);
    AppUtils.logApp(selectedSubtituteEmployeeId.value.toString());
    AppUtils.logApp(reason.value);

    final List<DateTime> dataLeaveList =
        multiDatePickerValueleaveRequestWithDefaultValue;

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
      multiDatePickerValueleaveRequestWithDefaultValue.value = [];
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
  }

  void onChangedPermit(String value) {
    valueListenerPermit.value = value;
    _filterPermitData(value, permitData, filterPermitData);
  }

  void clear() {
    search.clear();
    valueListener.value = '';
    filterLeaveData.value = leaveData;
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

  void _filterPermitData(String value, RxList<PermitDataModel> data,
      RxList<PermitDataModel> filterData) {
    if (value.isEmpty) {
      filterData.value = data;
      AppUtils.logApp('${filterData.length}');
    } else {
      filterData.value = data
          .where((e) =>
              e.codeNo.toLowerCase().contains(value.toLowerCase()) ||
              e.reason.toString().toLowerCase().contains(value.toLowerCase()) ||
              e.codeDefine
                  .toString()
                  .toLowerCase()
                  .contains(value.toLowerCase()))
          .toList();
      AppUtils.logApp('${filterData.length}');
    }
  }

// -- PERMIT FORM -- //

  Future<void> createFormPermit() async {
    final String formattedStartDate =
        selectedStartDatePermit.value.toIso8601String();
    final String formattedEndDate =
        selectedEndDatePermit.value.toIso8601String();

    AppUtils.logApp(formattedStartDate);
    AppUtils.logApp(formattedEndDate);

    String formatTimeOfDay(TimeOfDay time) {
      final now = DateTime.now();
      final dateTime =
          DateTime(now.year, now.month, now.day, time.hour, time.minute);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    }

    final String formattedStartTime = formatTimeOfDay(selectedStartTime.value);
    final String formattedEndTime = formatTimeOfDay(selectedEndTime.value);

    isLoading.value = true;

    final r = await createFormPermitUsecase(
      CreateFormPermitParamsEntity(
        typeCode: selectedPermitTypeCode.value,
        startDate: formattedStartDate,
        endDate: formattedEndDate,
        startTime: formattedStartTime,
        endTime: formattedEndTime,
        reason: reasonPermit.value,
      ),
    );

    r.fold(
      (l) {
        isLoading(false);
        final m = l.properties[0] as ApiException;
        AppUtils.logApp('${m.message}');
      },
      (r) {
        isLoading(false);
        Get.back();
        AppDialogImpl()
            .showSuccessSnackBar(description: 'Success Create Permit Leave');
      },
    );
  }
}
