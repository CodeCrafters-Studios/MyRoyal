import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tasks/controllers/detail_tasks_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class TabSubTaskView extends StatelessWidget {
  const TabSubTaskView({super.key, required this.controller});

  final DetailTasksController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Add Sub Task',
              style: TS.bodyMedium.copyWith(color: primary),
            ),
            10.horizontalSpace,
            const Icon(
              Icons.add_circle_outline_sharp,
              color: primary,
            )
          ],
        ),
        20.verticalSpace,
        Expanded(
          child: SizedBox(
            height: Get.height,
            child: ListView.separated(
              separatorBuilder: (_, __) => 20.verticalSpace,
              padding: REdgeInsets.only(bottom: 60),
              itemCount: controller.listSubTasks.length,
              itemBuilder: (_, index) {
                return Obx(
                  () => SubTaskCard(
                    title: controller.listSubTasks[index].title,
                    value: controller.checkStates[index].value,
                    onChanged: (value) {
                      controller.onChangedChecklist(value!, index);
                    },
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}

class SubTaskCard extends StatelessWidget {
  const SubTaskCard({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final void Function(bool?) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1, color: grey),
        borderRadius: BorderRadius.all(Radius.circular(Corners.slg)),
        color: white,
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Checkbox(
          side: const BorderSide(
            width: 2,
            color: primary,
          ),
          value: value,
          onChanged: onChanged,
        ),
        title: Text(
          title,
          style: TS.bodyMedium,
        ),
      ),
    );
  }
}
