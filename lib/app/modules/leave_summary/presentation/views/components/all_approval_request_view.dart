import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/leave_request_card.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/no_result_found.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/others/empty_data_widget.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:shimmer/shimmer.dart';

class AllApprovalRequestView extends StatelessWidget {
  const AllApprovalRequestView({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoading.value
        ? Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: SizedBox(
              height: Get.height,
              child: ListView.builder(
                padding: REdgeInsets.only(bottom: 280),
                itemCount: 10,
                itemBuilder: (_, __) {
                  return LeaveRequestCard(
                    onTap: () {},
                    fullname: '',
                    code: '',
                    date: '',
                    status: '',
                    iconStatus: 'assets/icons/ic_pending_summary.svg',
                    description: '',
                    statusColor: Colors.red,
                  );
                },
              ),
            ),
          )
        : controller.listLeaveApprovalRes.isEmpty
            ? const EmptyDataWidget()
            : controller.filterApprovalLeaveData.isNotEmpty
                ? SearchTextInheritedWidget(
                    searchText: RegExp.escape(controller.search.text),
                    child: SizedBox(
                      height: Get.height,
                      child: RefreshIndicator(
                        backgroundColor: white,
                        color: primary,
                        onRefresh: controller.onRefresh,
                        child: ListView.builder(
                          padding: REdgeInsets.only(bottom: 350),
                          itemCount: controller.filterApprovalLeaveData.length,
                          itemBuilder: (_, index) {
                            final r = controller.filterApprovalLeaveData[index];
                            return LeaveRequestCard(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return ConstrainedBox(
                                      constraints: BoxConstraints(
                                          maxHeight: 0.5 * Get.height),
                                      child: Container(
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            10.verticalSpace,
                                            Center(
                                              child: Container(
                                                width: 80.w,
                                                height: 5.h,
                                                decoration: BoxDecoration(
                                                  color: grey,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    40.r,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            20.verticalSpace,
                                            Center(
                                              child: Text(
                                                'Detail Form',
                                                style: TS.titleMedium,
                                              ),
                                            ),
                                            5.verticalSpace,
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                SizedBox(
                                                  width: 200.w,
                                                  child: ListTile(
                                                    horizontalTitleGap: 5.w,
                                                    leading: SvgPicture.asset(
                                                      height: 35.h,
                                                      width: 35.h,
                                                      'assets/icons/ic_date_summary.svg',
                                                    ),
                                                    title: Text(
                                                      'Date',
                                                      style: TS.titleSmall,
                                                    ),
                                                    subtitle: Text(
                                                      '${r.periode.start.substring(0, 2)}-${r.periode.end}',
                                                      style: TS.bodyMedium
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 150.w,
                                                  child: ListTile(
                                                    horizontalTitleGap: 5.w,
                                                    leading: SvgPicture.asset(
                                                      height: 35.h,
                                                      width: 35.h,
                                                      r.status == 'cancel'
                                                          ? 'assets/icons/ic_status_canceled.svg'
                                                          : r.status ==
                                                                  'approved'
                                                              ? 'assets/icons/ic_approved_summary.svg'
                                                              : 'assets/icons/ic_date_status.svg',
                                                    ),
                                                    title: Text(
                                                      'Status',
                                                      style: TS.titleSmall,
                                                    ),
                                                    subtitle: Text(
                                                      r.status.capitalizeFirst
                                                          .toString(),
                                                      style: TS.bodyMedium
                                                          .copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Image.asset(
                                                'assets/images/img_divider.png'),
                                            10.verticalSpace,
                                            SingleChildScrollView(
                                              child: Column(
                                                children: [
                                                  Center(
                                                    child: Text(
                                                      'Reason',
                                                      style: TS.titleSmall,
                                                    ),
                                                  ),
                                                  10.verticalSpace,
                                                  EPadding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 14,
                                                    ),
                                                    child: Text(
                                                      r.reason,
                                                      style: TS.bodyMedium
                                                          .copyWith(
                                                        color: greyText,
                                                      ),
                                                      textAlign:
                                                          TextAlign.start,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const Spacer(),
                                            Obx(
                                              () => controller.isLoading.value
                                                  ? Shimmer.fromColors(
                                                      baseColor: Colors.grey,
                                                      highlightColor:
                                                          Colors.grey.shade400,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child:
                                                                ButtonPrimary(
                                                              fullWidth: true,
                                                              margin:
                                                                  REdgeInsets
                                                                      .fromLTRB(
                                                                15,
                                                                0,
                                                                10,
                                                                20,
                                                              ),
                                                              text: '',
                                                              textColor: grey,
                                                              onPressed: null,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ButtonPrimary(
                                                              fullWidth: true,
                                                              margin:
                                                                  REdgeInsets
                                                                      .fromLTRB(
                                                                10,
                                                                0,
                                                                15,
                                                                20,
                                                              ),
                                                              text: '',
                                                              textColor: grey,
                                                              onPressed: null,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Row(
                                                      children: [
                                                        Expanded(
                                                          child: ButtonPrimary(
                                                            isLoading:
                                                                controller
                                                                    .isLoading
                                                                    .value,
                                                            fullWidth: true,
                                                            margin: REdgeInsets
                                                                .fromLTRB(
                                                              15,
                                                              0,
                                                              10,
                                                              20,
                                                            ),
                                                            text: 'Reject',
                                                            textColor: white,
                                                            onPressed: () => AppDialogImpl()
                                                                .showChoiceDialog(
                                                                    description:
                                                                        'Are you sure want to Reject this form?',
                                                                    onPressedNo:
                                                                        Get
                                                                            .back,
                                                                    onPressedYes:
                                                                        () {
                                                                      Get.dialog(
                                                                        Dialog(
                                                                          insetPadding:
                                                                              REdgeInsets.symmetric(horizontal: 40),
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.fromLTRB(
                                                                              Insets.xl,
                                                                              Insets.xl,
                                                                              Insets.xl,
                                                                              Insets.xs,
                                                                            ),
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              borderRadius: Corners.smBorder,
                                                                              color: Colors.white,
                                                                            ),
                                                                            child:
                                                                                Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                Text(
                                                                                  'Reason',
                                                                                  style: TS.titleMedium,
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                20.verticalSpace,
                                                                                InputPrimary(
                                                                                  maxLength: 1000,
                                                                                  maxLines: 5,
                                                                                  color: white,
                                                                                  outlineColor: primary,
                                                                                  hint: 'Type here..',
                                                                                  validation: (value) => value?.isEmpty ?? false ? 'Cannot be empty' : null,
                                                                                  onChanged: (value) {
                                                                                    controller.reasonText.value = value;
                                                                                    AppUtils.logApp(controller.reasonText.value);
                                                                                  },
                                                                                ),
                                                                                28.verticalSpace,
                                                                                Row(
                                                                                  children: [
                                                                                    Expanded(
                                                                                      child: ButtonPrimary(
                                                                                        onPressed: () {
                                                                                          controller.reasonText.value = '';
                                                                                          Get.back();
                                                                                        },
                                                                                        text: 'Cancel',
                                                                                        color: redPrimary,
                                                                                        fullWidth: true,
                                                                                      ),
                                                                                    ),
                                                                                    12.horizontalSpace,
                                                                                    Obx(
                                                                                      () => Expanded(
                                                                                        child: ButtonPrimary(
                                                                                          enable: controller.reasonText.value.isNotEmpty,
                                                                                          onPressed: () {
                                                                                            AppUtils.logApp(controller.reasonText.value);
                                                                                            Get.back();
                                                                                            Get.back();
                                                                                            controller.actionFormLeave(
                                                                                              r.codeNo,
                                                                                              'rejected',
                                                                                              r.level,
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
                                                                        barrierDismissible:
                                                                            false,
                                                                      );
                                                                    }),
                                                            color: red,
                                                            borderSide:
                                                                const BorderSide(
                                                              color: red,
                                                            ),
                                                          ),
                                                        ),
                                                        Expanded(
                                                          child: ButtonPrimary(
                                                            isLoading:
                                                                controller
                                                                    .isLoading
                                                                    .value,
                                                            fullWidth: true,
                                                            margin: REdgeInsets
                                                                .fromLTRB(
                                                              10,
                                                              0,
                                                              15,
                                                              20,
                                                            ),
                                                            text: 'Approve',
                                                            textColor: white,
                                                            onPressed: () => AppDialogImpl()
                                                                .showChoiceDialog(
                                                                    description:
                                                                        'Are you sure want to Approve this form?',
                                                                    onPressedNo:
                                                                        Get
                                                                            .back,
                                                                    onPressedYes:
                                                                        () {
                                                                      Get.back();
                                                                      controller
                                                                          .actionFormLeave(
                                                                        r.codeNo,
                                                                        'approved',
                                                                        r.level,
                                                                        '',
                                                                      );
                                                                    }),
                                                            color: green,
                                                            borderSide:
                                                                const BorderSide(
                                                              color: green,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            )
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              fullname: r.fullName,
                              code: r.codeNo,
                              date:
                                  '${r.periode.start.substring(0, 2)}-${r.periode.end}',
                              status: r.status,
                              iconStatus: r.status == 'pending'
                                  ? 'assets/icons/ic_pending_summary.svg'
                                  : r.status == 'cancel'
                                      ? 'assets/icons/ic_rejected_summar.svg'
                                      : 'assets/icons/ic_approved_summary.svg',
                              description: r.reason,
                              statusColor: r.status == 'pending'
                                  ? Colors.orangeAccent
                                  : r.status == 'cancel'
                                      ? Colors.red
                                      : green,
                            );
                          },
                        ),
                      ),
                    ),
                  )
                : const NoResultFoundWidget());
  }
}
