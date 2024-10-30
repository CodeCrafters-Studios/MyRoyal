import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/subtitute_employee_entity.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class ApplyLeaveView extends StatelessWidget {
  const ApplyLeaveView({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      resizeInsetsBottom: false,
      title: 'Create New',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              _buildLabel('Select Subtitute Employee'),
              10.verticalSpace,
              _buildSubtituteEmployeeDropdown(),
              20.verticalSpace,
              _buildMultiDateSelection(context),
              20.verticalSpace,
              _buildLabel('Reason for Leave'),
              5.verticalSpace,
              InputPrimary(
                maxLength: 1000,
                maxLines: 5,
                color: white,
                outlineColor: primary,
                key: const Key('inputTaskDesc'),
                hint: 'Type here..',
                hintStyle: TS.bodySmall.copyWith(color: greyHint),
                onChanged: (value) {
                  controller.reason.value = value;
                },
                validation: (value) =>
                    value?.isEmpty ?? false ? 'Cannot be empty' : null,
              ),
              const Spacer(),
              _buildApplyButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$text ',
            style: TS.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(
            text: '*',
            style: TS.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubtituteEmployeeDropdown() {
    return DropDownPrimary(
      label: '',
      hintText: 'Please choose subtitute employee',
      hintTextStyle: TS.bodySmall.copyWith(color: greyHint),
      borderColor: primary,
      items: controller
          .subtituteEmployeeListRes()
          .map<DropdownMenuItem<String>>((Employee value) {
        return DropdownMenuItem<String>(
          alignment: Alignment.centerLeft,
          value: value.fullName,
          child: Text(
            '${value.fullName} - ${value.employeeNumber}',
            style: TS.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      icon: controller.selectedSubtituteEmployee.value.isNotEmpty
          ? IconButton(
              onPressed: controller.clearSubtituteEmployee,
              icon: Icon(
                Icons.close,
                size: 20.r,
              ),
            )
          : const Icon(Icons.arrow_drop_down),
      value: controller.selectedSubtituteEmployee.value.isEmpty
          ? null
          : controller.selectedSubtituteEmployee.value,
      onChanged: (value) {
        final selectedSubtituteEmployeeId =
            controller.subtituteEmployeeListRes.firstWhere(
          (employee) => employee.fullName == value,
        );

        controller.setSubtituteEmployee(
          value!,
          selectedSubtituteEmployeeId.employeeId,
        );
      },
    );
  }

  Widget _buildMultiDateSelection(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: _buildDateButton(
          'Select Date',
          controller.multiDatePickerValueWithDefaultValue.isEmpty
              ? 'Select Date'
              : _getValueText(
                  controller.config.calendarType,
                  controller.multiDatePickerValueWithDefaultValue,
                ),
          () => showModalBottomSheet(
              isScrollControlled: true,
              context: context,
              builder: (_) {
                return FractionallySizedBox(
                    heightFactor: 0.65,
                    child: _buildMultiDatePickerWithValue());
              })
          // controller.selectStartDate(context),
          ),
    );
  }

  Widget _buildDateButton(
    String label,
    String selectedDate,
    VoidCallback onTap,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        3.verticalSpace,
        InkWell(
          onTap: onTap,
          child: Container(
            width: Get.width,
            padding: REdgeInsets.all(10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: primary)),
            child: Text(
              selectedDate,
              style: TS.bodySmall.copyWith(
                color: controller.multiDatePickerValueWithDefaultValue.isEmpty
                    ? greyHint
                    : black,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton() {
    return Obx(
      () => ButtonPrimary(
        enable: controller.selectedSubtituteEmployee.isNotEmpty &&
            controller.multiDatePickerValueWithDefaultValue.isNotEmpty &&
            controller.reason.value.isNotEmpty,
        isLoading: controller.isLoading.value,
        fullWidth: true,
        margin: REdgeInsets.symmetric(vertical: 20),
        text: 'Apply',
        onPressed: controller.createFormLeave,
      ),
    );
  }

  Widget _buildMultiDatePickerWithValue() {
    return Container(
      padding: REdgeInsets.only(left: 5, top: 10, right: 5),
      height: 500.h,
      width: Get.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Container(
              width: 80.w,
              height: 5.h,
              decoration: BoxDecoration(
                  color: grey, borderRadius: BorderRadius.circular(40.r)),
            ),
          ),
          20.verticalSpace,
          Container(
            margin: REdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                border: Border.all(color: primary),
                borderRadius: BorderRadius.circular(8)),
            child: CalendarDatePicker2(
              config: controller.config,
              value: controller.multiDatePickerValueWithDefaultValue,
              onValueChanged: (dates) =>
                  controller.multiDatePickerValueWithDefaultValue.value = dates,
            ),
          ),
          const Spacer(),
          ButtonPrimary(
            fullWidth: true,
            margin: REdgeInsets.fromLTRB(14, 0, 14, 20),
            text: 'Done',
            textColor: white,
            onPressed: () => Get.back(),
            color: primary,
          )
        ],
      ),
    );
  }

  String _getValueText(
    CalendarDatePicker2Type datePickerType,
    List<DateTime?> values,
  ) {
    values =
        values.map((e) => e != null ? DateUtils.dateOnly(e) : null).toList();
    var valueText = (values.isNotEmpty ? values[0] : null)
        .toString()
        .replaceAll('00:00:00.000', '');

    if (datePickerType == CalendarDatePicker2Type.multi) {
      valueText = values.isNotEmpty
          ? values
              .map((v) => v.toString().replaceAll('00:00:00.000', ''))
              .join(', ')
          : 'null';
    } else if (datePickerType == CalendarDatePicker2Type.range) {
      if (values.isNotEmpty) {
        final startDate = values[0].toString().replaceAll('00:00:00.000', '');
        final endDate = values.length > 1
            ? values[1].toString().replaceAll('00:00:00.000', '')
            : 'null';
        valueText = '$startDate to $endDate';
      } else {
        return 'null';
      }
    }

    return valueText;
  }
}
