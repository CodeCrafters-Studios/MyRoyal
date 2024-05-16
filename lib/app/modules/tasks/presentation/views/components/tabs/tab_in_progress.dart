import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class TabInProgressTasks extends StatelessWidget {
  const TabInProgressTasks({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300.h,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: controller.listInProgressTasksDummy.length,
        itemBuilder: (ctx, index) {
          final r = controller.listInProgressTasksDummy[index];
          return _buildTaskCard(
            title: r.title,
            status: r.status,
            progress: r.progress,
            progressColor: r.progressColor,
            taskStatusColor: r.taskStatusColor,
            date: r.date,
            member: r.member,
          );
        },
      ),
    );
  }
}

Widget _buildTaskCard({
  required String title,
  required String status,
  required String date,
  required String member,
  required double progress,
  required Color progressColor,
  required Color taskStatusColor,
}) {
  return CardApp(
    margin: REdgeInsets.only(bottom: 15),
    borderWidth: 1,
    isOutlined: true,
    width: Get.width,
    isShadow: true,
    shadows: Shadows.small,
    child: EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Column(
        children: [
          _buildTaskTitleRow(
            title: title,
            status: status,
            taskStatusColor: taskStatusColor,
          ),
          10.verticalSpace,
          _buildTaskProgressRow(
            progress: progress,
            progressColor: progressColor,
          ),
          10.verticalSpace,
          LinearProgressIndicator(
            color: progressColor,
            backgroundColor: greyHint,
            value: progress,
          ),
          20.verticalSpace,
          _buildTaskFooterRow(
            date: date,
            member: member,
          ),
        ],
      ),
    ),
  );
}

Widget _buildTaskTitleRow({
  required String title,
  required String status,
  required Color taskStatusColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Expanded(
        flex: 2,
        child: Text(
          title,
          style: TS.bodyLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      Container(
        width: 100.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          color: taskStatusColor.withOpacity(0.3),
        ),
        child: Center(
          child: Text(
            status,
            style: TS.bodyMedium.copyWith(
              color: taskStatusColor.withOpacity(0.8),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _buildTaskProgressRow({
  required double progress,
  required Color progressColor,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Progress',
        style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w600),
      ),
      Text(
        '${(progress * 100).toInt()}% complete',
        style: TS.bodyMedium.copyWith(
          color: progressColor.withOpacity(0.8),
        ),
      ),
    ],
  );
}

Widget _buildTaskFooterRow({required String date, required String member}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Due Date: $date',
        style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
      ),
      Row(
        children: [
          Text(
            '$member persons',
            style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
          ),
          SizedBox(width: 5.w),
          const Icon(
            Icons.people_alt_outlined,
            color: Colors.grey,
            size: 24,
          ),
        ],
      ),
    ],
  );
}
