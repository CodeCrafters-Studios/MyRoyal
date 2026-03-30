import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/tasks_view_base.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';

class ToDoTasksView extends StatelessWidget {
  const ToDoTasksView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return TaskViewBase(
      title: 'To-Do Tasks',
      searchHint: 'Search',
      searchLabel: '',
      onChanged: (value) {},
      taskCount: controller.listToDoTasksDummy.length,
      taskCardBuilder: (_, index) {
        final r = controller.listToDoTasksDummy[index];
        return TaskCard(
          onTap: () => Get.toNamed(Routes.DETAIL_TASKS),
          title: r.title,
          status: r.status,
          progress: r.progress,
          progressColor: r.progressColor,
          statusColor: r.taskStatusColor,
          dueDate: r.date,
          member: r.member,
        );
      },
    );
  }
}
