import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TaskListView extends StatelessWidget {
  const TaskListView({
    super.key,
    required this.taskCount,
    required this.taskCardBuilder,
  });

  final int taskCount;
  final Widget Function(BuildContext, int) taskCardBuilder;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      child: SizedBox(
        height: 625.h,
        child: ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: taskCount,
          itemBuilder: taskCardBuilder,
        ),
      ),
    );
  }
}
