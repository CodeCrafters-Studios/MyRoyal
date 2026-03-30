import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/tasks/domain/entities/task_dummy_data.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/task_type_card.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/widgets/others/ticker_provider.dart';

class TasksController extends GetxController {
  TasksController({required this.appDialog});

  late final TabController tabController;
  final AppDialog appDialog;

  RxString selectedStartDate = 'Select date'.obs;
  RxString selectedEndDate = 'Select date'.obs;
  RxInt currentIndex = 0.obs;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  List<TasksDummyData> listAllTasksDummy = <TasksDummyData>[
    TasksDummyData(
      title: 'Mobile Application Design',
      status: 'To-Do',
      progress: 0.1,
      progressColor: Colors.red,
      taskStatusColor: Colors.blue,
      date: '17, May 2024',
      member: '5',
    ),
    TasksDummyData(
      title: 'Wireframe Design',
      status: 'In-Progress',
      progress: 0.60,
      progressColor: Colors.orangeAccent,
      taskStatusColor: Colors.orangeAccent,
      date: '10, May 2024',
      member: '3',
    ),
    TasksDummyData(
      title: 'Dashboard Design',
      status: 'In-Progress',
      progress: 0.80,
      progressColor: Colors.orangeAccent,
      taskStatusColor: Colors.orangeAccent,
      date: '10, May 2024',
      member: '3',
    ),
    TasksDummyData(
      title: 'Wireframe Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '8',
    ),
    TasksDummyData(
      title: 'Dashboard Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '6',
    ),
    TasksDummyData(
      title: 'Mobile Application Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '3',
    ),
  ];

  List<TasksDummyData> listLastTasksDummy = <TasksDummyData>[];

  List<TasksDummyData> listToDoTasksDummy = <TasksDummyData>[
    TasksDummyData(
      title: 'Mobile Application Design',
      status: 'To-Do',
      progress: 0.1,
      progressColor: Colors.red,
      taskStatusColor: Colors.blue,
      date: '17, May 2024',
      member: '5',
    ),
  ];

  List<TasksDummyData> listInProgressTasksDummy = <TasksDummyData>[
    TasksDummyData(
      title: 'Wireframe Design',
      status: 'In-Progress',
      progress: 0.60,
      progressColor: Colors.orangeAccent,
      taskStatusColor: Colors.orangeAccent,
      date: '10, May 2024',
      member: '3',
    ),
    TasksDummyData(
      title: 'Dashboard Design',
      status: 'In-Progress',
      progress: 0.80,
      progressColor: Colors.orangeAccent,
      taskStatusColor: Colors.orangeAccent,
      date: '10, May 2024',
      member: '3',
    ),
  ];

  List<TasksDummyData> listCompletedTasksDummy = <TasksDummyData>[
    TasksDummyData(
      title: 'Wireframe Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '8',
    ),
    TasksDummyData(
      title: 'Dashboard Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '6',
    ),
    TasksDummyData(
      title: 'Mobile Application Design Meeting',
      status: 'Completed',
      progress: 1,
      progressColor: green,
      taskStatusColor: green,
      date: '3, May 2024',
      member: '3',
    ),
  ];

  List<TasksDummyData> listCanceledTasksDummy = <TasksDummyData>[
    TasksDummyData(
      title: 'Landing Page',
      status: 'Canceled',
      progress: 0,
      progressColor: grey,
      taskStatusColor: Colors.red,
      date: '12, May 2024',
      member: '4',
    ),
    TasksDummyData(
      title: 'User Interface Design',
      status: 'Canceled',
      progress: 0,
      progressColor: grey,
      taskStatusColor: Colors.red,
      date: '13, May 2024',
      member: '6',
    ),
    TasksDummyData(
      title: 'Email Reply Testing',
      status: 'Canceled',
      progress: 0,
      progressColor: grey,
      taskStatusColor: Colors.red,
      date: '14, May 2024',
      member: '2',
    ),
    TasksDummyData(
      title: 'Sales Analytic Design Meeting',
      status: 'Canceled',
      progress: 0,
      progressColor: grey,
      taskStatusColor: Colors.red,
      date: '15, May 2024',
      member: '2',
    ),
  ];

  List<TaskTypeCard> listTaskType = <TaskTypeCard>[
    TaskTypeCard(
      type: 'To-Do',
      onTap: () {},
      texColor: white,
      backgroundColor: primary,
      borderColor: primary,
    ),
    TaskTypeCard(
      type: 'In-Progress',
      onTap: () {},
      texColor: primary,
      backgroundColor: white,
      borderColor: primary,
    )
  ];

  @override
  void onInit() {
    _filterLastTasks();
    tabController = TabController(length: 4, vsync: TicckerProvider());
    super.onInit();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void _filterLastTasks() {
    if (listAllTasksDummy.length >= 3) {
      listLastTasksDummy = listAllTasksDummy.sublist(0, 3);
    } else {
      listLastTasksDummy = listAllTasksDummy;
    }
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

  void selectTaskType(int index) {
    currentIndex.value = index;
    AppUtils.logApp('Selected task type index: ${currentIndex.value}');
  }
}
