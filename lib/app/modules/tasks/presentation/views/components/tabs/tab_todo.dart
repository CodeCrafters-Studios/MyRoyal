import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';

class TabToDoTasks extends StatelessWidget {
  const TabToDoTasks({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listToDoTasksDummy.length,
        itemBuilder: (_, index) {
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
      ),
    );
  }
}
