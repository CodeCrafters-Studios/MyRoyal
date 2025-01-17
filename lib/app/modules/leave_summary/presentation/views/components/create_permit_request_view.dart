import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/leave_summary/domain/entities/permit_type_entity.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class CreatePermitRequestView extends StatelessWidget {
  const CreatePermitRequestView({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel('Type of Permit Request'),
            _buildPermitTypeDropdown(),
            20.verticalSpace,
            _buildDateSelection(context),
            20.verticalSpace,
            _buildTimeSelection(context),
            20.verticalSpace,
            _buildLabel('Reason'),
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
                controller.reasonPermit.value = value;
              },
              validation: (value) =>
                  value?.isEmpty ?? false ? 'Cannot be empty' : null,
            ),
            const Spacer(flex: 2),
            _buildApplyButton(),
            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSelection(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              'Time Start',
              controller.selectedStartTimePermitFormatted.value.isEmpty
                  ? 'Select time'
                  : controller.selectedStartTimePermitFormatted.value,
              controller.selectedStartTimePermitFormatted.value.isEmpty,
              () async {
                final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial);
                if (time != null) {
                  controller.selectedStartTime.value = time;

                  final now = DateTime.now();
                  final formattedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                    now.second,
                  );

                  controller.selectedStartTimePermitFormatted.value =
                      DateFormat('HH:mm a').format(formattedDateTime);

                  AppUtils.logApp(
                      'SELECTED START TIME ${controller.selectedStartTimePermitFormatted.value}');
                }
              },
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: _buildButton(
              'Time End',
              controller.selectedEndTimePermitFormatted.value.isEmpty
                  ? 'Select time'
                  : controller.selectedEndTimePermitFormatted.value,
              controller.selectedEndTimePermitFormatted.value.isEmpty,
              () async {
                final TimeOfDay? time = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                    initialEntryMode: TimePickerEntryMode.dial);
                if (time != null) {
                  controller.selectedEndTime.value = time;

                  final now = DateTime.now();
                  final formattedDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    time.hour,
                    time.minute,
                    now.second,
                  );

                  controller.selectedEndTimePermitFormatted.value =
                      DateFormat('HH:mm a').format(formattedDateTime);
                  AppUtils.logApp('SELECTED END TIME $time');
                }
              },
            ),
          ),
        ],
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

  Widget _buildPermitTypeDropdown() {
    return DropDownPrimary(
      label: '',
      hintText: 'Please choose permit type',
      hintTextStyle: TS.bodySmall.copyWith(color: greyHint),
      borderColor: primary,
      items: controller.permitTypeList
          .map<DropdownMenuItem<String>>((PermitTypeEntity value) {
        return DropdownMenuItem<String>(
          alignment: Alignment.centerLeft,
          value: value.type,
          child: Text.rich(
            TextSpan(
              text: '${value.type} / ',
              children: [
                TextSpan(
                  text: value.typeTranslate,
                  style: TS.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            style: TS.bodySmall,
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      icon: controller.selectedPermitType.value.isNotEmpty
          ? IconButton(
              onPressed: controller.clearPermitType,
              icon: Icon(
                Icons.close,
                size: 20.r,
              ),
            )
          : const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: secondary,
            ),
      value: controller.selectedPermitType.value.isEmpty
          ? null
          : controller.selectedPermitType.value,
      onChanged: (value) {
        final selectedPermitType = controller.permitTypeList.firstWhere(
          (permit) => permit.type == value,
          orElse: () =>
              PermitTypeEntity(type: '', typeCode: '', typeTranslate: ''),
        );
        controller.setPermitType(value!, selectedPermitType.typeCode);
      },
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        children: [
          Expanded(
            child: _buildButton(
              'Date Start',
              controller.selectedStartDatePermit.value == DateTime(0)
                  ? 'Select date'
                  : DateFormat('dd MMMM yyy')
                      .format(controller.selectedStartDatePermit.value),
              controller.selectedStartDatePermit.value == DateTime(0),
              () => showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                currentDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime(DateTime.now().year + 50),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      datePickerTheme: DatePickerThemeData(
                        dividerColor: Colors.transparent,
                      ),
                      colorScheme: ColorScheme.light(primary: primary),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: primary),
                      ),
                    ),
                    child: child!,
                  );
                  // Theme(
                  //   data: Theme.of(context).copyWith(
                  //     datePickerTheme: DatePickerThemeData(
                  //       dividerColor: Colors.transparent,
                  //       backgroundColor: primary,
                  //     ),
                  //     colorScheme: ColorScheme.light(
                  //       primary: secondary2, // header background color
                  //       onPrimary: Colors.black, // header text color
                  //       onSurface: Colors.white, // body text color
                  //     ),
                  //     textButtonTheme: TextButtonThemeData(
                  //       style: TextButton.styleFrom(
                  //         foregroundColor: urgentColor, // button text color
                  //       ),
                  //     ),
                  //   ),
                  //   child: child!,
                  // );
                },
              ).then(
                (DateTime? selected) {
                  if (selected != null) {
                    controller.selectedStartDatePermit.value = selected;
                    controller.selectedEndDatePermit.value = DateTime(0);
                    AppUtils.logApp(
                      '${controller.selectedStartDatePermit.value}',
                    );
                  }
                },
              ),
              // showModalBottomSheet(
              //       isDismissible: false,
              //       isScrollControlled: true,
              //       context: context,
              //       builder: (_) {
              //         return FractionallySizedBox(
              //           heightFactor: 0.65,
              //           child: _buildMultiDatePickerWithValue(),
              //         );
              //       },
              //     )
              // controller.selectStartDate(context),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: _buildButton(
              'Date End',
              controller.selectedEndDatePermit.value == DateTime(0)
                  ? 'Select date'
                  : DateFormat('dd MMMM yyy')
                      .format(controller.selectedEndDatePermit.value),
              controller.selectedEndDatePermit.value == DateTime(0),
              () => showDatePicker(
                context: context,
                initialDate:
                    controller.selectedStartDatePermit.value == DateTime(0)
                        ? DateTime.now()
                        : controller.selectedStartDatePermit.value,
                currentDate: DateTime.now(),
                firstDate:
                    controller.selectedStartDatePermit.value == DateTime(0)
                        ? DateTime.now()
                        : controller.selectedStartDatePermit.value,
                lastDate: DateTime(DateTime.now().year + 50),
                initialEntryMode: DatePickerEntryMode.calendarOnly,
                builder: (context, child) {
                  return Theme(
                    data: Theme.of(context).copyWith(
                      datePickerTheme: DatePickerThemeData(
                        dividerColor: Colors.transparent,
                      ),
                      colorScheme: ColorScheme.light(primary: primary),
                      textButtonTheme: TextButtonThemeData(
                        style: TextButton.styleFrom(foregroundColor: primary),
                      ),
                    ),
                    child: child!,
                  );
                },
              ).then((DateTime? selected) {
                if (selected != null) {
                  controller.selectedEndDatePermit.value = selected;
                  AppUtils.logApp('${controller.selectedEndDatePermit.value}');
                }
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton(
    String label,
    String selectedValue,
    bool selectedColor,
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
              selectedValue,
              style: TS.bodySmall.copyWith(
                color: selectedColor ? greyHint : black,
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
        enable: controller.selectedPermitType.isNotEmpty &&
            controller.selectedStartTimePermitFormatted.isNotEmpty &&
            controller.selectedEndTimePermitFormatted.isNotEmpty &&
            controller.reasonPermit.value.isNotEmpty,
        isLoading: controller.isLoading.value,
        fullWidth: true,
        margin: REdgeInsets.symmetric(vertical: 20),
        text: 'Apply',
        onPressed: controller.createFormPermit,
      ),
    );
  }
}
