import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/create_task_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/type_tasks/view_all_tasks_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/type_tasks/cancel_tasks_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/type_tasks/completed_taks_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/type_tasks/in_progress_tasks_view.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_card.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/tasks_category.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/type_tasks/todo_taks_view.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/tasks_controller.dart';

class TasksView extends GetView<TasksController> {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    return TaskViewImpl(controller: controller);
  }
}

class TaskViewImpl extends StatelessWidget {
  const TaskViewImpl({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: '',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            _buildHeader(),
            _buildTaskCategories(),
            10.verticalSpace,
            _buildLatestTasksReport(),
            15.verticalSpace,
            _buildLatestTasksList(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('My Tasks', style: TS.titleLarge),
            Text(
              DateFormat('E, MMM yyyy').format(DateTime.now()),
              style: TS.bodyMedium,
            ),
          ],
        ),
        ButtonPrimary(
          margin: REdgeInsets.only(left: 20, top: 5, right: 20),
          color: primary.withOpacity(0.85),
          fullWidth: false,
          onPressed: () => Get.to(() => CreateTaskView(controller: controller)),
          child: Row(
            children: [
              Icon(Icons.add, size: 20.dm, color: white),
              5.horizontalSpace,
              Text(
                'Add Task',
                style: TS.bodyMedium.copyWith(
                  color: white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskCategories() {
    return SizedBox(
      height: 300.h,
      child: GridView.count(
        childAspectRatio: 1.5,
        mainAxisSpacing: 15,
        crossAxisSpacing: 15,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        shrinkWrap: true,
        children: [
          TaskCategoryCard(
            title: 'To-Do',
            tasksCount: controller.listToDoTasksDummy.length,
            color: Colors.blue,
            icon: Icons.checklist_outlined,
            onTap: () => Get.to(() => ToDoTasksView(controller: controller)),
          ),
          TaskCategoryCard(
            title: 'In-Progress',
            tasksCount: controller.listInProgressTasksDummy.length,
            color: Colors.orangeAccent,
            icon: Icons.timer_outlined,
            onTap: () =>
                Get.to(() => InProgressTasksView(controller: controller)),
          ),
          TaskCategoryCard(
            title: 'Completed',
            tasksCount: controller.listCompletedTasksDummy.length,
            color: Colors.green,
            icon: Icons.check_box_outlined,
            onTap: () =>
                Get.to(() => CompletedTasksView(controller: controller)),
          ),
          TaskCategoryCard(
            title: 'Cancel',
            tasksCount: controller.listCanceledTasksDummy.length,
            color: red,
            icon: Icons.warning_amber_rounded,
            onTap: () => Get.to(() => CancelTasksView(controller: controller)),
          ),
        ],
      ),
    );
  }

  Widget _buildLatestTasksReport() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('My latest tasks report', style: TS.titleLarge),
        InkWellTap(
          onTap: () => Get.to(
            () => ViewAllTasksView(controller: controller),
          ),
          child: Text('View All', style: TS.bodyMedium),
        ),
      ],
    );
  }

  Widget _buildLatestTasksList() {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listLastTasksDummy.length,
        itemBuilder: (_, index) {
          final r = controller.listLastTasksDummy[index];
          return TaskCard(
            onTap: () => Get.toNamed(Routes.DETAIL_TASKS),
            title: r.title,
            status: r.status,
            progress: r.progress,
            statusColor: r.taskStatusColor,
            progressColor: r.progressColor,
            dueDate: r.date,
            member: r.member,
          );
        },
      ),
    );
  }
}
