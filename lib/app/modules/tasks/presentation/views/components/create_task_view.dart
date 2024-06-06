import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tasks/presentation/controllers/tasks_controller.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/employee_card.dart';
import 'package:iroyal/app/modules/tasks/presentation/views/components/shared/task_type_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class CreateTaskView extends StatelessWidget {
  const CreateTaskView({super.key, required this.controller});

  final TasksController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Create Task',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            InputPrimary(
              color: white,
              outlineColor: primary,
              key: const Key('inputTaskTitle'),
              label: 'Task Name',
              hint: 'Type here..',
              onChanged: (value) {},
              validation: (value) =>
                  value?.isEmpty ?? false ? 'Cannot be empty' : null,
            ),
            20.verticalSpace,
            InputPrimary(
              maxLength: 1000,
              maxLines: 5,
              color: white,
              outlineColor: primary,
              key: const Key('inputTaskDesc'),
              label: 'Task Description',
              hint: 'Type here..',
              onChanged: (value) {},
              validation: (value) =>
                  value?.isEmpty ?? false ? 'Cannot be empty' : null,
            ),
            20.verticalSpace,
            _buildDatePickers(context),
            20.verticalSpace,
            _buildTaskAssignSection(),
            20.verticalSpace,
            _buildTaskTypeSection(),
            const Spacer(),
            _buildButtonPrimarySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonPrimarySection() {
    return ButtonPrimary(
      margin: REdgeInsets.symmetric(vertical: 20),
      key: const Key('createTaskBtn'),
      onPressed: () {},
      text: 'Create Task',
      fullWidth: true,
    );
  }

  Widget _buildDatePickers(BuildContext context) {
    return Row(
      children: <Widget>[
        _buildDatePicker(
          label: 'Start Date',
          selectedDate: controller.selectedStartDate,
          onSelectDate: () => controller.selectStartDate(context),
        ),
        16.horizontalSpace,
        _buildDatePicker(
          label: 'End Date',
          selectedDate: controller.selectedEndDate,
          onSelectDate: () => controller.selectEndDate(context),
        ),
      ],
    );
  }

  Widget _buildDatePicker({
    required String label,
    required RxString selectedDate,
    required VoidCallback onSelectDate,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: TextAlign.start,
          style: TS.labelLarge,
        ),
        3.verticalSpace,
        ButtonPrimary(
          margin: REdgeInsets.only(top: 5),
          padding: REdgeInsets.symmetric(
            horizontal:
                controller.selectedStartDate.value == 'Select date' ? 15 : 10,
            vertical: 5,
          ),
          color: white,
          borderSide: const BorderSide(color: primary),
          fullWidth: false,
          onPressed: onSelectDate,
          suffixIcon: const Icon(Icons.calendar_today, color: primary),
          child: Text(
            selectedDate.value,
            style: TS.bodyMedium.copyWith(
              color: primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTaskAssignSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Assign to',
          textAlign: TextAlign.start,
          style: TS.labelLarge,
        ),
        5.verticalSpace,
        Row(
          children: [
            SizedBox(
              height: 50.h,
              width: 45.w,
              child: Image.asset('assets/icons/ic_circle_plus.png'),
            ),
            10.horizontalSpace,
            SizedBox(
              height: 50.h,
              width: 288.w,
              child: ListView.separated(
                separatorBuilder: (_, __) => 8.horizontalSpace,
                scrollDirection: Axis.horizontal,
                itemCount: 3,
                itemBuilder: (_, __) {
                  return const EmployeeCard();
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTaskTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Task Type',
          textAlign: TextAlign.start,
          style: TS.labelLarge,
        ),
        5.verticalSpace,
        Row(
          children: [
            SizedBox(
              height: 50.h,
              width: 343.w,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                separatorBuilder: (_, __) => 8.horizontalSpace,
                itemCount: controller.listTaskType.length,
                itemBuilder: (_, index) {
                  final r = controller.listTaskType[index];
                  return Obx(
                    () => TaskTypeCard(
                      texColor: controller.currentIndex.value == index
                          ? white
                          : primary,
                      type: r.type,
                      backgroundColor: controller.currentIndex.value == index
                          ? primary
                          : white,
                      borderColor: controller.currentIndex.value == index
                          ? white
                          : primary,
                      onTap: () {
                        controller.selectTaskType(index);
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ],
    );
  }
}
