import 'package:another_stepper/another_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/presentation/controllers/detail_tracking_document_controller.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/presentation/views/components/bottom_sheet_button.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/presentation/views/components/shimmer_bottom_sheet_button.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

class StatusDocumentView extends StatelessWidget {
  const StatusDocumentView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    final trackingDocument = controller.trackingDocumentListData;

    return Obx(
      () => Scaffold(
        backgroundColor: white,
        body: SizedBox(
          height: Get.height,
          child: Column(
            children: [
              controller.isLoading.value
                  ? EPadding(
                      padding: REdgeInsets.only(left: 20),
                      child: AnotherStepper(
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        stepperList: [
                          StepperData(
                            iconWidget: Container(
                              padding: REdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: grey50,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                '',
                                style: TS.labelMedium.copyWith(
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                            ),
                          ),
                          StepperData(
                            iconWidget: Container(
                              padding: REdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: grey50,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                '',
                                style: TS.labelMedium.copyWith(
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                            ),
                          ),
                          StepperData(
                            iconWidget: Container(
                              padding: REdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: grey50,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(30),
                                ),
                              ),
                              child: Center(
                                  child: Text(
                                '',
                                style: TS.labelMedium.copyWith(
                                  color: white,
                                  fontWeight: FontWeight.w700,
                                ),
                              )),
                            ),
                          ),
                        ],
                        stepperDirection: Axis.vertical,
                        iconWidth: 40.w,
                        iconHeight: 40.h,
                        activeBarColor: Colors.grey,
                        inActiveBarColor: Colors.grey,
                        verticalGap: 35,
                        activeIndex: 1,
                        barThickness: 1,
                      ),
                    )
                  : EPadding(
                      padding: REdgeInsets.only(left: 20),
                      child: AnotherStepper(
                        scrollPhysics: const NeverScrollableScrollPhysics(),
                        stepperList: controller.stepperData,
                        stepperDirection: Axis.vertical,
                        iconWidth: 40.w,
                        iconHeight: 40.h,
                        activeBarColor: Colors.grey,
                        inActiveBarColor: Colors.grey,
                        verticalGap: 35,
                        activeIndex: 1,
                        barThickness: 1,
                      ),
                    ),
            ],
          ),
        ),
        bottomSheet: controller.isLoading.value
            ? const ShimmerBottomSheetButton()
            : trackingDocument.needApproval
                ? BottomSheetButton(
                    onTapRejcet: () => AppDialogImpl().showChoiceDialog(
                          title: 'Confirmation',
                          description:
                              'Are you sure want to reject this document?',
                          onPressedYes: () {
                            AppUtils.logApp('HERE');
                            Get.dialog(
                              Dialog(
                                insetPadding:
                                    REdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Insets.xl,
                                    Insets.xl,
                                    Insets.xl,
                                    Insets.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: Corners.smBorder,
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Reason',
                                        style: TS.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      20.verticalSpace,
                                      InputPrimary(
                                        controller: controller.reason,
                                        maxLength: 1000,
                                        maxLines: 5,
                                        color: white,
                                        outlineColor: primary,
                                        hint: 'Type here..',
                                        validation: (value) =>
                                            value?.isEmpty ?? false
                                                ? 'Cannot be empty'
                                                : null,
                                        onChanged: (value) {
                                          controller.reasonText.value = value;
                                          AppUtils.logApp(
                                              controller.reasonText.value);
                                        },
                                      ),
                                      28.verticalSpace,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ButtonPrimary(
                                              onPressed: () => Get.back(),
                                              text: 'Cancel',
                                              color: red,
                                              fullWidth: true,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Obx(
                                            () => Expanded(
                                              child: ButtonPrimary(
                                                enable: controller.reasonText
                                                    .value.isNotEmpty,
                                                onPressed: () {
                                                  AppUtils.logApp(controller
                                                      .reasonText.value);
                                                  Get.back();
                                                  Get.back();
                                                  controller.postActionDocument(
                                                    trackingDocument.id,
                                                    'reject',
                                                    controller.reasonText.value,
                                                  );
                                                },
                                                text: 'Submit',
                                                color: green,
                                                fullWidth: true,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      16.verticalSpace,
                                    ],
                                  ),
                                ),
                              ),
                              barrierDismissible: false,
                            );
                          },
                        ),
                    onTapApprove: () => AppDialogImpl().showChoiceDialog(
                        title: 'Confirmation',
                        description:
                            'Are you sure want to approve this document?',
                        onPressedYes: () {
                          Get.back();
                          controller.postActionDocument(
                            trackingDocument.id,
                            'approve',
                            '',
                          );
                        }))
                : null,
      ),
    );
  }
}
