import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_view_base.dart';
import 'package:iroyal/app/routes/app_pages.dart';

class InProgressTasksView extends StatelessWidget {
  const InProgressTasksView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return TaskViewBase(
      title: 'In-progress Tasks',
      searchHint: 'Search',
      searchLabel: '',
      onChanged: (value) {},
      taskCount: controller.listInProgressTasksDummy.length,
      taskCardBuilder: (ctx, index) {
        final r = controller.listInProgressTasksDummy[index];
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
