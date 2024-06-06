import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/attendance_summary/domain/entities.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class AttendanceSummaryController extends GetxController {
  List<LeaveRequestDummyData> listAllLeaveRequestDummy =
      <LeaveRequestDummyData>[
    LeaveRequestDummyData(
      date: '17, May 2024',
      description: 'Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Approved',
      types: 'Sick',
      statusColor: green,
    ),
    LeaveRequestDummyData(
      date: '17, May 2024',
      description: 'Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Pending',
      types: 'Sick',
      statusColor: Colors.orangeAccent,
    ),
    LeaveRequestDummyData(
      date: '17, May 2024',
      description: 'Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Rejected',
      types: 'Casual',
      statusColor: Colors.red,
    ),
    LeaveRequestDummyData(
      date: '17, May 2024',
      description: 'Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Approved',
      types: 'Sick',
      statusColor: green,
    ),
    LeaveRequestDummyData(
      date: '17, May 2024',
      description:
          'Lorem Ipsum dolor sit amet, consecture adipiscing elit.Lorem Ipsum dolor sit amet, consecture adipiscing elit.Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Pending',
      types: 'Sick',
      statusColor: Colors.orangeAccent,
    ),
    LeaveRequestDummyData(
      date: '17, May 2024',
      description: 'Lorem Ipsum dolor sit amet, consecture adipiscing elit.',
      status: 'Rejected',
      types: 'Casual',
      statusColor: Colors.red,
    ),
  ];

  List<LeaveRequestDummyData> listCasualDummy = <LeaveRequestDummyData>[];
  List<LeaveRequestDummyData> listSickDummy = <LeaveRequestDummyData>[];

  late final TabController tabController;

  RxBool isCasual = false.obs;
  RxBool isSick = false.obs;

  RxString selectedStartDate = 'Select date'.obs;
  RxString selectedEndDate = 'Select date'.obs;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: TicckerProvider());
    filterTypesLeaveRequest();
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void selectCasualType() {
    isCasual.value = true;
    isSick.value = false;
  }

  void selectSickType() {
    isSick.value = true;
    isCasual.value = false;
  }

  Future<void> selectStartDate(BuildContext context) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate:
          selectedStartDate.value == 'Select date' ? DateTime.now() : startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    if (d != null) {
      selectedStartDate.value = DateFormat.yMMMd("en_US").format(d);
      startDate = d;
      if (selectedEndDate.value != 'Select date' &&
          startDate.isAfter(endDate)) {
        selectedEndDate.value = DateFormat.yMMMd("en_US").format(d);
        endDate = d;
      }
      AppUtils.logApp('Selected start date: $startDate');
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    DateTime? d = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: startDate,
      lastDate: DateTime(2025),
    );
    if (d != null) {
      selectedEndDate.value = DateFormat.yMMMd("en_US").format(d);
      endDate = d;
      AppUtils.logApp('Selected end date: $endDate');
    }
  }

  void filterTypesLeaveRequest() {
    // Clear the existing lists
    listSickDummy.clear();
    listCasualDummy.clear();

    // Iterate over the listAllLeaveRequestDummy and add items to respective lists
    for (var element in listAllLeaveRequestDummy) {
      if (element.types == 'Sick') {
        listSickDummy.add(element);
      } else if (element.types == 'Casual') {
        listCasualDummy.add(element);
      }
    }

    // Log the lengths of the lists for verification
    AppUtils.logApp('Sick Leaves Count: ${listSickDummy.length}');
    AppUtils.logApp('Casual Leaves Count: ${listCasualDummy.length}');
  }
}
