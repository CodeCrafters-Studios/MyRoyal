import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/attendance_summary/controllers/attendance_summary_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class ApplyLeaveView extends StatelessWidget {
  const ApplyLeaveView({super.key, required this.controller});

  final AttendanceSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      bottomBarHeight: 100.h,
      bottomBar: ButtonPrimary(
        margin: REdgeInsets.symmetric(vertical: 22, horizontal: 14),
        text: 'Apply',
        onPressed: () {
          showModalBottomSheet(
            enableDrag: false,
            isDismissible: false,
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(25.0),
              ),
            ),
            builder: (context) {
              return SizedBox(
                height: 500.h,
                width: Get.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    15.verticalSpace,
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 5.h,
                        decoration: BoxDecoration(
                            color: grey,
                            borderRadius: BorderRadius.circular(40.r)),
                      ),
                    ),
                    30.verticalSpace,
                    EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Request Pending',
                        style: TS.titleMedium,
                      ),
                    ),
                    20.verticalSpace,
                    Center(
                      child: Container(
                        height: 180.h,
                        padding: const EdgeInsets.symmetric(horizontal: 14),
                        child: Image.asset(
                          'assets/images/img_bg_request_pending.png',
                        ),
                      ),
                    ),
                    10.verticalSpace,
                    EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Your request has been received and we will let you know as soon as possible.',
                        style: TS.titleMedium.copyWith(color: greyText),
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
      ),
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AppbarSpacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Type of leave ',
                      style: TS.bodyMedium,
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
              ),
              5.verticalSpace,
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ButtonPrimary(
                      margin: REdgeInsets.only(top: 5),
                      padding: REdgeInsets.symmetric(
                        horizontal: 53,
                        vertical: 8,
                      ),
                      color: controller.isCasual.value ? primary : white,
                      borderSide: const BorderSide(color: primary),
                      fullWidth: false,
                      onPressed: controller.selectCasualType,
                      child: Center(
                        child: Text(
                          'Casual',
                          style: TS.bodyMedium.copyWith(
                            color: controller.isCasual.value ? white : primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    ButtonPrimary(
                      margin: REdgeInsets.only(top: 5),
                      padding: REdgeInsets.symmetric(
                        horizontal: 62,
                        vertical: 8,
                      ),
                      color: controller.isSick.value ? primary : white,
                      borderSide: const BorderSide(color: primary),
                      fullWidth: false,
                      onPressed: controller.selectSickType,
                      child: Center(
                        child: Text(
                          'Sick',
                          style: TS.bodyMedium.copyWith(
                            color: controller.isSick.value ? white : primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              SizedBox(
                width: Get.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Start Date ',
                                style: TS.bodyMedium,
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
                        ),
                        3.verticalSpace,
                        ButtonPrimary(
                          margin: REdgeInsets.only(top: 5),
                          padding: REdgeInsets.symmetric(
                            horizontal: controller.selectedStartDate.value ==
                                    'Select date'
                                ? 15
                                : 10,
                            vertical: 5,
                          ),
                          color: white,
                          borderSide: const BorderSide(color: primary),
                          fullWidth: false,
                          onPressed: () => controller.selectStartDate(context),
                          suffixIcon:
                              const Icon(Icons.calendar_today, color: primary),
                          child: Text(
                            controller.selectedStartDate.value,
                            style: TS.bodyMedium.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'End Date ',
                                style: TS.bodyMedium,
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
                        ),
                        3.verticalSpace,
                        ButtonPrimary(
                          suffixIcon:
                              const Icon(Icons.calendar_today, color: primary),
                          margin: REdgeInsets.only(top: 5),
                          padding: REdgeInsets.symmetric(
                            horizontal: controller.selectedEndDate.value ==
                                    'Select date'
                                ? 15
                                : 10,
                            vertical: 5,
                          ),
                          color: white,
                          borderSide: const BorderSide(color: primary),
                          fullWidth: false,
                          onPressed: () => controller.selectEndDate(context),
                          child: Text(
                            controller.selectedEndDate.value,
                            style: TS.bodyMedium.copyWith(
                              color: primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Reason for Leave ',
                      style: TS.bodyMedium,
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
              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
