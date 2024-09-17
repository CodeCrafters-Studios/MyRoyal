import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/controllers/leave_summary_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
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
              _buildLabel('Type of leave'),
              5.verticalSpace,
              _buildLeaveTypeButtons(),
              20.verticalSpace,
              _buildDateSelection(context),
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
                onChanged: (value) {},
                validation: (value) =>
                    value?.isEmpty ?? false ? 'Cannot be empty' : null,
              ),
              const Spacer(),
              _buildApplyButton(context),
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

  Widget _buildLeaveTypeButtons() {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildLeaveTypeButton(
            'Casual',
            controller.isCasual.value,
            controller.selectCasualType,
            horizontalPadding: 50,
          ),
          _buildLeaveTypeButton(
            'Sick',
            controller.isSick.value,
            controller.selectSickType,
            horizontalPadding: 55,
          ),
        ],
      ),
    );
  }

  Widget _buildLeaveTypeButton(
    String text,
    bool isSelected,
    VoidCallback onPressed, {
    double? horizontalPadding,
  }) {
    return ButtonPrimary(
      margin: REdgeInsets.only(top: 5),
      padding: REdgeInsets.symmetric(
          horizontal: horizontalPadding ?? 0, vertical: 8),
      color: isSelected ? primary : white,
      borderSide: const BorderSide(color: primary),
      fullWidth: false,
      onPressed: onPressed,
      child: Center(
        child: Text(
          text,
          style: TS.bodyMedium.copyWith(
            color: isSelected ? white : primary,
          ),
        ),
      ),
    );
  }

  Widget _buildDateSelection(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildDateButton(
            'Start Date',
            controller.selectedStartDate.value,
            () => controller.selectStartDate(context),
            horizontalPadding: 18,
          ),
          _buildDateButton(
            'End Date',
            controller.selectedEndDate.value,
            () => controller.selectEndDate(context),
          ),
        ],
      ),
    );
  }

  Widget _buildDateButton(
    String label,
    String selectedDate,
    VoidCallback onPressed, {
    double? horizontalPadding,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(label),
        3.verticalSpace,
        ButtonPrimary(
          margin: REdgeInsets.only(top: 5),
          padding: REdgeInsets.symmetric(
            horizontal: horizontalPadding ?? 15,
            vertical: 5,
          ),
          color: white,
          borderSide: const BorderSide(color: primary),
          fullWidth: false,
          onPressed: onPressed,
          suffixIcon: const Icon(Icons.calendar_today, color: primary),
          child: Text(
            selectedDate,
            style: TS.bodyMedium.copyWith(
              color: primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildApplyButton(BuildContext context) {
    return ButtonPrimary(
      fullWidth: true,
      margin: REdgeInsets.symmetric(vertical: 20),
      text: 'Apply',
      onPressed: () {
        showModalBottomSheet(
          enableDrag: false,
          isDismissible: false,
          context: context,
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.r),
                  topRight: Radius.circular(25.r),
                ),
                color: white,
              ),
              height: 500.h,
              width: Get.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  10.verticalSpace,
                  Center(
                    child: Container(
                      width: 80.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          color: grey,
                          borderRadius: BorderRadius.circular(40.r)),
                    ),
                  ),
                  20.verticalSpace,
                  EPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Request Pending',
                      style: TS.titleMedium,
                    ),
                  ),
                  40.verticalSpace,
                  Center(
                    child: Container(
                      height: 150.h,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Image.asset(
                        'assets/images/img_bg_request_pending.png',
                      ),
                    ),
                  ),
                  40.verticalSpace,
                  EPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text(
                      'Your request has been received and we will let you know as soon as possible.',
                      style: TS.bodyMedium.copyWith(color: greyText),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  50.verticalSpace,
                  ButtonPrimary(
                    fullWidth: true,
                    margin: REdgeInsets.symmetric(horizontal: 14),
                    text: 'Continue',
                    onPressed: () => Get.back(),
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }
}
