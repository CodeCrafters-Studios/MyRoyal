import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_view_base.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/styles.dart';

class CancelTasksView extends StatelessWidget {
  const CancelTasksView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return TaskViewBase(
      title: 'Canceled Tasks',
      searchHint: 'Search',
      searchLabel: '',
      onChanged: (value) {},
      taskCount: controller.listCanceledTasksDummy.length,
      taskCardBuilder: (_, index) {
        final r = controller.listCanceledTasksDummy[index];
        return TaskCard(
          onTap: () => Get.toNamed(Routes.DETAIL_TASKS),
          title: r.title,
          status: r.status,
          progress: r.progress,
          statusColor: r.taskStatusColor,
          dueDate: r.date,
          member: r.member,
          titleStyle: TS.bodyLarge.copyWith(
            fontWeight: FontWeight.w600,
            decoration: TextDecoration.lineThrough,
          ),
          dateStyle: TS.bodyMedium.copyWith(
            fontWeight: FontWeight.w400,
            decoration: TextDecoration.lineThrough,
          ),
        );
      },
    );
  }
}
