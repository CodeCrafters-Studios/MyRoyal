import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:iroyal/app/routes/app_pages.dart';

class TabCompletedTasks extends StatelessWidget {
  const TabCompletedTasks({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listCompletedTasksDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listCompletedTasksDummy[index];
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
      ),
    );
  }
}
