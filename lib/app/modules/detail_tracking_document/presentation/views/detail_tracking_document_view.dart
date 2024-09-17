import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/tabs/details.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/tabs/status.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/tabs/header.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/views/components/status_approval.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';

import '../controllers/detail_tracking_document_controller.dart';

class DetailTrackingDocumentView
    extends GetView<DetailTrackingDocumentController> {
  const DetailTrackingDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWellTap(
          onTap: () => Get.back(),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.w,
            color: Colors.black,
          ),
        ),
        backgroundColor: white,
        foregroundColor: white,
        surfaceTintColor: white,
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            backgroundColor: white,
            foregroundColor: white,
            surfaceTintColor: white,
            flexibleSpace: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.isLoading.value
                        ? ShimmerText(
                            width: 300,
                            height: controller
                                        .trackingDocumentListData.title.length >
                                    30
                                ? 50.h
                                : 20.h,
                          )
                        : Text(
                            controller.trackingDocumentListData.title,
                            style: TS.titleLarge.copyWith(
                              color: black,
                            ),
                          ),
                    15.verticalSpace,
                    controller.isLoading.value
                        ? ShimmerText(
                            width: 100.w,
                            height: 20.h,
                          )
                        : StatusApproval(
                            borderColor: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? green
                                    : red
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? primary50
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? urgentColor
                                        : red,
                            decorationColor: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? green
                                    : red
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? primary50
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? urgentColor
                                        : red,
                            icon: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? Icons.check
                                    : Icons.close
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? Icons.info
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? Icons.bolt
                                        : Icons.warning,
                            iconColor: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? green
                                    : red
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? primary50
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? urgentColor
                                        : red,
                            status: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? 'APPROVED'
                                    : 'REJECTED'
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? 'ON TIME'
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? 'URGENT'
                                        : 'OVERDUE',
                            statusColor: controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved' ||
                                    controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'reject'
                                ? controller
                                            .detailTrackingDocDataModel()
                                            .data
                                            .detailPtk
                                            .state ==
                                        'approved'
                                    ? green
                                    : red
                                : controller.trackingDocumentListData
                                            .stateTargetCompletionDate ==
                                        'On Time'
                                    ? primary50
                                    : controller.trackingDocumentListData
                                                .stateTargetCompletionDate ==
                                            'Urgent'
                                        ? urgentColor
                                        : red,
                          ),
                  ],
                ),
              ),
            ),
            automaticallyImplyLeading: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(
                controller.trackingDocumentListData.title.length > 30
                    ? 100.h
                    : 65.h,
              ),
              child: Stack(
                fit: StackFit.passthrough,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: grey, width: 2.0),
                      ),
                    ),
                  ),
                  TabBar(
                    tabAlignment: TabAlignment.fill,
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: controller.tabController,
                    labelStyle: TS.bodyMedium,
                    labelColor: black,
                    indicatorColor: black,
                    unselectedLabelColor: greyText,
                    isScrollable: false,
                    tabs: const [
                      Tab(text: 'Headers'),
                      Tab(text: 'Details'),
                      // Tab(text: 'Attachment'),
                      Tab(text: 'Status'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: controller.tabController,
          children: [
            HeaderDocumentView(controller: controller),
            DetailsDocumentView(controller: controller),
            // const AttachmentsView(),
            StatusDocumentView(controller: controller),
          ],
        ),
      ),
    );
  }
}
