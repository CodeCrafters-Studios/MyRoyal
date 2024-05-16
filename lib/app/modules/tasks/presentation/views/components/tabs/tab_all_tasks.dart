import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';

class TabAllTasks extends StatelessWidget {
  const TabAllTasks({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listAllTasksDummy.length,
        itemBuilder: (ctx, index) {
          final r = controller.listAllTasksDummy[index];
          return TaskCard(
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
