import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/leave_summary/domain/entities/permit_type_entity.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/dropdown/dropdown_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

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
            _buildLabel('Tipe pengajuan izin'),
            _buildPermitTypeDropdown(),
            20.verticalSpace,
            _buildDateSelection(context),
            20.verticalSpace,
            _buildTimeSelection(context),
            20.verticalSpace,
            _buildLabel('Alasan pengajuan izin'),
            5.verticalSpace,
            InputPrimary(
              controller: controller.reasonPermitText,
              maxLength: 1000,
              maxLines: 5,
              color: white,
              outlineColor: primary,
              key: const Key('inputTaskDesc'),
              hint: 'Ketik disini..',
              hintStyle: TS.bodySmall.copyWith(color: greyHint),
              onChanged: (value) {
                controller.reasonPermit.value = value;
              },
              validation: (value) =>
                  value?.isEmpty ?? false ? 'Tidak boleh kosong' : null,
            ),
            const Spacer(flex: 2),
            _buildApplyButton(),
            const Spacer(flex: 3),
            20.verticalSpace,
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
              'Waktu mulai',
              controller.selectedStartTimePermitFormatted.value.isEmpty
                  ? 'Pilih waktu'
                  : controller.selectedStartTimePermitFormatted.value,
              controller.selectedStartTimePermitFormatted.value.isEmpty,
              () async {
                final TimeOfDay? time = await showTimePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          timePickerTheme: TimePickerThemeData(
                            backgroundColor: white,
                            dayPeriodTextColor: black,
                            dayPeriodColor: primary.withOpacity(0.1),
                            dayPeriodShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          datePickerTheme: DatePickerThemeData(
                            dividerColor: Colors.transparent,
                          ),
                          colorScheme: ColorScheme.light(primary: primary),
                          textButtonTheme: TextButtonThemeData(
                            style:
                                TextButton.styleFrom(foregroundColor: primary),
                          ),
                        ),
                        child: child!,
                      );
                    },
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
              'Waktu Selesai',
              controller.selectedEndTimePermitFormatted.value.isEmpty
                  ? 'Pilih waktu'
                  : controller.selectedEndTimePermitFormatted.value,
              controller.selectedEndTimePermitFormatted.value.isEmpty,
              () async {
                final TimeOfDay? time = await showTimePicker(
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          timePickerTheme: TimePickerThemeData(
                            backgroundColor: white,
                            dayPeriodTextColor: black,
                            dayPeriodColor: primary.withOpacity(0.1),
                            dayPeriodShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          datePickerTheme: DatePickerThemeData(
                            dividerColor: Colors.transparent,
                          ),
                          colorScheme: ColorScheme.light(primary: primary),
                          textButtonTheme: TextButtonThemeData(
                            style:
                                TextButton.styleFrom(foregroundColor: primary),
                          ),
                        ),
                        child: child!,
                      );
                    },
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
      hintText: 'Pilih tipe pengajuan izin',
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
              'Tanggal Mulai',
              controller.selectedStartDatePermit.value == DateTime(0)
                  ? 'Pilih tanggal'
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
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: _buildButton(
              'Tanggal Selesai',
              controller.selectedEndDatePermit.value == DateTime(0)
                  ? 'Pilih tanggal'
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
              border: Border.all(color: primary),
              color: white,
            ),
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
        text: 'Kirim',
        onPressed: controller.createFormPermit,
      ),
    );
  }
}
