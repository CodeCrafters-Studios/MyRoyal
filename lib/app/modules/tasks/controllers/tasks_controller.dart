import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/domain/entities/task_dummy_data.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class TasksController extends GetxController {
  late final TabController tabController;

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

  void _filterLastTasks() {
    if (listAllTasksDummy.length >= 3) {
      // Get 3 latest data
      // listLastTasksDummy =
      //     listAllTasksDummy.sublist(listAllTasksDummy.length - 3);

      listLastTasksDummy = listAllTasksDummy.sublist(0, 3);
    } else {
      listLastTasksDummy = listAllTasksDummy;
    }
  }
}
