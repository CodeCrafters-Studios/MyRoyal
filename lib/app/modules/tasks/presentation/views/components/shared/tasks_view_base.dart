import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/search_bar_custom.dart';
import 'package:MyRoyal/app/modules/tasks/presentation/views/components/shared/tasks_list_view.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

class TaskViewBase extends StatelessWidget {
  const TaskViewBase({
    super.key,
    required this.title,
    required this.taskCount,
    required this.searchHint,
    required this.searchLabel,
    required this.onChanged,
    required this.taskCardBuilder,
  });

  final String title;
  final String searchHint;
  final String searchLabel;
  final int taskCount;
  final Function(String) onChanged;
  final Widget Function(BuildContext, int) taskCardBuilder;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      resizeInsetsBottom: false,
      title: title,
      child: Column(
        children: [
          const AppbarSpacer(),
          SearchBarCustom(
            hint: searchHint,
            label: searchLabel,
            onChanged: onChanged,
          ),
          10.verticalSpace,
          TaskListView(
            taskCount: taskCount,
            taskCardBuilder: taskCardBuilder,
          ),
        ],
      ),
    );
  }
}
