import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/leave_request_card.dart';
import 'package:iroyal/app/modules/leave_summary/presentation/views/components/no_result_found.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/others/empty_data_widget.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:shimmer/shimmer.dart';

class AllLeaveRequestView extends StatelessWidget {
  const AllLeaveRequestView({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value && controller.filterData.isEmpty
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
          : controller.yearlyLeaveModelRes.isNotEmpty
              ? controller.filterData.isNotEmpty
                  ? SearchTextInheritedWidget(
                      searchText: RegExp.escape(controller.search.text),
                      child: SizedBox(
                        height: Get.height,
                        child: ListView.builder(
                          padding: REdgeInsets.only(bottom: 280),
                          itemCount: controller.filterData.length,
                          itemBuilder: (_, index) {
                            final r = controller.filterData[index];
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
                                                            40.r)),
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
                                                    subtitle: Row(
                                                      children: [
                                                        Expanded(
                                                          child: DropdownButton<
                                                              String>(
                                                            items: r.listPeriode.map<
                                                                DropdownMenuItem<
                                                                    String>>((String
                                                                value) {
                                                              return DropdownMenuItem<
                                                                  String>(
                                                                value: value,
                                                                child:
                                                                    Text(value),
                                                              );
                                                            }).toList(),
                                                            value: r
                                                                .listPeriode[0],
                                                            onChanged: (String?
                                                                newValue) {
                                                              // Handle the value change
                                                            },
                                                            icon: const Icon(Icons
                                                                .arrow_drop_down),
                                                          ),
                                                          //  Text(
                                                          //             r.listPeriode
                                                          //                         .length ==
                                                          //                     1
                                                          //                 ? r.listPeriode[
                                                          //                     0]
                                                          //                 : r.listPeriode
                                                          //                             .length ==
                                                          //                         2
                                                          //                     ? '${r.listPeriode[0]} - ${r.listPeriode[1]}'
                                                          //                     : '${r.listPeriode[0].substring(0, 6)}, ${r.listPeriode[1]}, etc',
                                                          //             style: TS.bodyMedium
                                                          //                 .copyWith(
                                                          //                     fontWeight:
                                                          //                         FontWeight
                                                          //                             .w300),
                                                          //           ),
                                                        ),
                                                      ],
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
                                                                          14,
                                                                          0,
                                                                          14,
                                                                          20),
                                                              text: '',
                                                              textColor:
                                                                  primary,
                                                              onPressed: null,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ButtonPrimary(
                                                              fullWidth: true,
                                                              margin:
                                                                  REdgeInsets
                                                                      .fromLTRB(
                                                                          14,
                                                                          0,
                                                                          14,
                                                                          20),
                                                              text: '',
                                                              textColor: white,
                                                              onPressed: null,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : r.canCancel
                                                      ? Row(children: [
                                                          Expanded(
                                                            child:
                                                                ButtonPrimary(
                                                              fullWidth: true,
                                                              margin:
                                                                  REdgeInsets
                                                                      .fromLTRB(
                                                                          14,
                                                                          0,
                                                                          14,
                                                                          20),
                                                              text: 'Close',
                                                              textColor: white,
                                                              onPressed:
                                                                  Get.back,
                                                              color: primary,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color: primary,
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child:
                                                                ButtonPrimary(
                                                              fullWidth: true,
                                                              margin:
                                                                  REdgeInsets
                                                                      .fromLTRB(
                                                                          14,
                                                                          0,
                                                                          14,
                                                                          20),
                                                              text: 'Cancel',
                                                              textColor: white,
                                                              onPressed: () => AppDialogImpl()
                                                                  .showChoiceDialog(
                                                                      description:
                                                                          'Are you sure want to cancel this form?',
                                                                      onPressedNo: Get
                                                                          .back,
                                                                      onPressedYes:
                                                                          () {
                                                                        Get.back();
                                                                        controller
                                                                            .cancelFormLeave(
                                                                          r.codeNo,
                                                                        );
                                                                      }),
                                                              color: secondary,
                                                              borderSide:
                                                                  const BorderSide(
                                                                color:
                                                                    secondary,
                                                              ),
                                                            ),
                                                          ),
                                                        ])
                                                      : ButtonPrimary(
                                                          fullWidth: true,
                                                          margin: REdgeInsets
                                                              .fromLTRB(14, 0,
                                                                  14, 20),
                                                          text: 'Close',
                                                          textColor: white,
                                                          onPressed: Get.back,
                                                          color: primary,
                                                          borderSide:
                                                              const BorderSide(
                                                            color: primary,
                                                          ),
                                                        ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              fullname: '',
                              code: r.codeNo,
                              date: r.listPeriode.length > 2
                                  ? '${r.listPeriode[0].substring(0, 6)}, ${r.listPeriode[1]} and more'
                                  : r.listPeriode.length == 1
                                      ? r.listPeriode[0]
                                      : '${r.listPeriode[0]} - ${r.listPeriode[1]}',
                              status: r.status,
                              iconStatus: r.status == 'pending'
                                  ? 'assets/icons/ic_pending_summary.svg'
                                  : r.status == 'cancel' ||
                                          r.status == 'rejected'
                                      ? 'assets/icons/ic_rejected_summar.svg'
                                      : 'assets/icons/ic_approved_summary.svg',
                              description: r.reason,
                              statusColor: r.status == 'pending'
                                  ? Colors.orangeAccent
                                  : r.status == 'cancel' ||
                                          r.status == 'rejected'
                                      ? Colors.red
                                      : green,
                            );
                          },
                        ),
                      ),
                    )
                  : const NoResultFoundWidget()
              : const Center(child: EmptyDataWidget()),
    );
  }
}
