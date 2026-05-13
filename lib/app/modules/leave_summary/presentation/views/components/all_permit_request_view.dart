import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/controllers/leave_summary_controller.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/leave_request_card.dart';
import 'package:MyRoyal/app/modules/leave_summary/presentation/views/components/no_result_found.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/others/empty_data_widget.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:shimmer/shimmer.dart';

class AllPermitRequestView extends StatelessWidget {
  const AllPermitRequestView({super.key, required this.controller});

  final LeaveSummaryController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.permitData.isEmpty
          ? EmptyDataWidget()
          : Stack(
              children: [
                controller.isLoading.value
                    ? Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        child: SizedBox(
                          height: Get.height,
                          child: ListView.builder(
                            itemCount: 10,
                            itemBuilder: (_, __) {
                              return LeaveRequestCard(
                                onTap: () {},
                                fullname: '',
                                code: '',
                                date: '',
                                status: '',
                                iconStatus:
                                    'assets/icons/ic_pending_summary.svg',
                                description: '',
                                statusColor: black,
                              );
                            },
                          ),
                        ),
                      )
                    : controller.permitData.isEmpty
                        ? const Center(child: EmptyDataWidget())
                        : controller.filterPermitData.isNotEmpty
                            ? SearchTextInheritedWidget(
                                searchText:
                                    RegExp.escape(controller.search.text),
                                child: RepaintBoundary(
                                  child: RefreshIndicator(
                                    edgeOffset: 60.h,
                                    backgroundColor: white,
                                    color: primary,
                                    onRefresh: controller.onRefresh,
                                    child: ListView.builder(
                                      padding: EdgeInsets.only(
                                        top: 65.h,
                                        bottom: 200.h,
                                      ),
                                      shrinkWrap: true,
                                      itemCount:
                                          controller.filterPermitData.length,
                                      itemBuilder: (_, index) {
                                        final r =
                                            controller.filterPermitData[index];
                                        return LeaveRequestCard(
                                          fullname: '',
                                          code: r.codeNo,
                                          date: r.periodDate.length > 2
                                              ? '${r.periodDate[0].substring(0, 6)}, ${r.periodDate[1]} and more'
                                              : r.periodDate.length == 1
                                                  ? r.periodDate[0]
                                                  : '${r.periodDate[0]} - ${r.periodDate[1]}',
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
                                          onTap: () {
                                            showModalBottomSheet(
                                              context: context,
                                              builder: (context) {
                                                return ConstrainedBox(
                                                  constraints: BoxConstraints(
                                                    maxHeight: 0.8 * Get.height,
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            1,
                                                  ),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                          25.r,
                                                        ),
                                                        topRight:
                                                            Radius.circular(
                                                          25.r,
                                                        ),
                                                      ),
                                                      color: bgColorDropDown,
                                                    ),
                                                    height: 500.h,
                                                    width: Get.width,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        25.verticalSpace,
                                                        Center(
                                                          child: Text(
                                                            'Detail Pengajuan Izin',
                                                            style:
                                                                TS.titleMedium,
                                                          ),
                                                        ),
                                                        25.verticalSpace,
                                                        EPadding(
                                                          padding:
                                                              EdgeInsets.only(
                                                            left: 14,
                                                          ),
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              SizedBox(
                                                                width: 190.w,
                                                                child: Row(
                                                                  children: [
                                                                    SvgPicture
                                                                        .asset(
                                                                      height:
                                                                          35.h,
                                                                      width:
                                                                          35.h,
                                                                      'assets/icons/ic_date_summary.svg',
                                                                    ),
                                                                    5.horizontalSpace,
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          'Tanggal',
                                                                          style:
                                                                              TS.titleSmall,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            r.periodDate.length > 1
                                                                                ? DropdownButtonHideUnderline(
                                                                                    child: DropdownButton<String>(
                                                                                      isDense: true,
                                                                                      padding: EdgeInsets.zero,
                                                                                      dropdownColor: white,
                                                                                      items: r.periodDate.toSet().map<DropdownMenuItem<String>>((String value) {
                                                                                        return DropdownMenuItem<String>(
                                                                                          value: value.isNotEmpty ? value : null,
                                                                                          child: Text(
                                                                                            value,
                                                                                          ),
                                                                                        );
                                                                                      }).toList(),
                                                                                      value: r.periodDate.isNotEmpty ? r.periodDate.toSet().first : null,
                                                                                      style: TS.bodyMedium.copyWith(
                                                                                        color: black,
                                                                                        fontWeight: FontWeight.w300,
                                                                                      ),
                                                                                      onChanged: (String? newValue) {},
                                                                                      icon: const Icon(
                                                                                        Icons.arrow_drop_down,
                                                                                      ),
                                                                                    ),
                                                                                  )
                                                                                : Text(
                                                                                    r.periodDate[0],
                                                                                    style: TS.bodyMedium.copyWith(
                                                                                      fontWeight: FontWeight.w300,
                                                                                    ),
                                                                                  ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              EPadding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .only(
                                                                  right: 14,
                                                                ),
                                                                child: Row(
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .end,
                                                                      children: [
                                                                        Text(
                                                                          'Status',
                                                                          style:
                                                                              TS.titleSmall,
                                                                        ),
                                                                        Text(
                                                                          r.status
                                                                              .capitalizeFirst
                                                                              .toString(),
                                                                          style: TS
                                                                              .bodyMedium
                                                                              .copyWith(
                                                                            fontWeight:
                                                                                FontWeight.w300,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                    5.horizontalSpace,
                                                                    SvgPicture
                                                                        .asset(
                                                                      height:
                                                                          35.h,
                                                                      width:
                                                                          35.h,
                                                                      r.status == 'cancel' ||
                                                                              r.status == 'rejected'
                                                                          ? 'assets/icons/ic_status_canceled.svg'
                                                                          : r.status == 'approved'
                                                                              ? 'assets/icons/ic_approved_detail_summary.svg'
                                                                              : 'assets/icons/ic_date_status.svg',
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Image.asset(
                                                          'assets/images/img_divider.png',
                                                        ),
                                                        10.verticalSpace,
                                                        SingleChildScrollView(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              EPadding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            14),
                                                                child: Text(
                                                                  'Alasan:',
                                                                  style: TS
                                                                      .titleSmall,
                                                                ),
                                                              ),
                                                              10.verticalSpace,
                                                              EPadding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      14,
                                                                ),
                                                                child:
                                                                    Container(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          10),
                                                                  width:
                                                                      Get.width,
                                                                  height: 210.h,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color:
                                                                        white,
                                                                    border: Border.all(
                                                                        color:
                                                                            borderColor),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            10),
                                                                  ),
                                                                  child: Text(
                                                                    r.reason,
                                                                    style: TS
                                                                        .bodyMedium
                                                                        .copyWith(
                                                                      color:
                                                                          greyText,
                                                                    ),
                                                                    textAlign:
                                                                        TextAlign
                                                                            .start,
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        const Spacer(),
                                                        Obx(
                                                          () => controller
                                                                  .isLoading
                                                                  .value
                                                              ? Shimmer
                                                                  .fromColors(
                                                                  baseColor:
                                                                      Colors
                                                                          .grey,
                                                                  highlightColor:
                                                                      Colors
                                                                          .grey
                                                                          .shade400,
                                                                  child: Row(
                                                                    children: [
                                                                      Expanded(
                                                                        child:
                                                                            ButtonPrimary(
                                                                          fullWidth:
                                                                              true,
                                                                          margin:
                                                                              REdgeInsets.fromLTRB(
                                                                            14,
                                                                            0,
                                                                            14,
                                                                            20,
                                                                          ),
                                                                          text:
                                                                              '',
                                                                          textColor:
                                                                              primary,
                                                                          onPressed:
                                                                              null,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            ButtonPrimary(
                                                                          fullWidth:
                                                                              true,
                                                                          margin:
                                                                              REdgeInsets.fromLTRB(
                                                                            14,
                                                                            0,
                                                                            14,
                                                                            20,
                                                                          ),
                                                                          text:
                                                                              '',
                                                                          textColor:
                                                                              white,
                                                                          onPressed:
                                                                              null,
                                                                          color:
                                                                              Colors.grey,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : r.canCancel
                                                                  ? Row(
                                                                      children: [
                                                                          Expanded(
                                                                            child:
                                                                                ButtonPrimary(
                                                                              fullWidth: true,
                                                                              margin: REdgeInsets.fromLTRB(
                                                                                14,
                                                                                0,
                                                                                14,
                                                                                20,
                                                                              ),
                                                                              text: 'Tutup',
                                                                              textColor: white,
                                                                              onPressed: Get.back,
                                                                              color: primary,
                                                                              borderSide: const BorderSide(
                                                                                color: primary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Expanded(
                                                                            child:
                                                                                ButtonPrimary(
                                                                              fullWidth: true,
                                                                              margin: REdgeInsets.fromLTRB(
                                                                                14,
                                                                                0,
                                                                                14,
                                                                                20,
                                                                              ),
                                                                              text: 'Batal',
                                                                              textColor: white,
                                                                              onPressed: () => AppDialogImpl().showChoiceDialog(
                                                                                description: 'Apakah anda yakin ingin membatalkan pengajuan izin ini?',
                                                                                onPressedNo: Get.back,
                                                                                onPressedYes: () {
                                                                                  Get.back();
                                                                                  Get.back();
                                                                                  controller.cancelForm(
                                                                                    r.codeNo,
                                                                                    'permit',
                                                                                  );
                                                                                },
                                                                              ),
                                                                              color: secondary,
                                                                              borderSide: const BorderSide(
                                                                                color: secondary,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ])
                                                                  : ButtonPrimary(
                                                                      fullWidth:
                                                                          true,
                                                                      margin: REdgeInsets
                                                                          .fromLTRB(
                                                                        14,
                                                                        0,
                                                                        14,
                                                                        20,
                                                                      ),
                                                                      text:
                                                                          'Tutup',
                                                                      textColor:
                                                                          white,
                                                                      onPressed:
                                                                          Get.back,
                                                                      color:
                                                                          primary,
                                                                      borderSide:
                                                                          const BorderSide(
                                                                        color:
                                                                            primary,
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
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              )
                            : const Center(
                                child: NoResultFoundWidget(),
                              ),
                controller.permitData.isEmpty ? emptyBox : _buildSearch(),
              ],
            ),
    );
  }

  Widget _buildSearch() {
    return Obx(
      () => EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: InputPrimary(
          controller: controller.search,
          label: '',
          hint: 'Cari',
          onChanged: controller.onChanged,
          color: white,
          outlineColor: primary,
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
        ),
      ),
    );
  }

  Widget _buildPrefixIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    final valueListener = controller.valueListener.value;
    return valueListener.isNotEmpty
        ? IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear),
          )
        : null;
  }
}
