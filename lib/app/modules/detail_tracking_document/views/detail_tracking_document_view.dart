import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/attachments.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/details.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/status.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/header.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //             StatusApproval(
                  //                     borderColor: d.stateTargetCompletionDate == 'On Time'
                  //     ? primary50
                  //     : controller.listDataApproval.stateTargetCompletionDate == 'Urgent'
                  //         ? urgentColor
                  //         : red,
                  // decorationColor: d.stateTargetCompletionDate == 'On Time'
                  //     ? primary50
                  //     : d.stateTargetCompletionDate == 'Urgent'
                  //         ? urgentColor
                  //         : red,
                  // icon: d.stateTargetCompletionDate == 'On Time'
                  //     ? Icons.info
                  //     : d.stateTargetCompletionDate == 'Urgent'
                  //         ? Icons.bolt
                  //         : Icons.warning,
                  // iconColor: d.stateTargetCompletionDate == 'On Time'
                  //     ? primary50
                  //     : d.stateTargetCompletionDate == 'Urgent'
                  //         ? urgentColor
                  //         : red,
                  // status: d.stateTargetCompletionDate == 'On Time'
                  //     ? 'ON TIME'
                  //     : d.stateTargetCompletionDate == 'Urgent'
                  //         ? 'URGENT'
                  //         : 'OVERDUE',
                  // statusColor: d.stateTargetCompletionDate == 'On Time'
                  //     ? primary50
                  //     : d.stateTargetCompletionDate == 'Urgent'
                  //         ? urgentColor
                  //         : red,
                  //                   ),
                  // 5.verticalSpace,
                  Text(
                    'Request for man power replacement',
                    style: TS.titleLarge.copyWith(
                      color: black,
                    ),
                  ),
                ],
              ),
            ),
            expandedHeight: 155.h,
            automaticallyImplyLeading: false,
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(100.h),
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
                    tabAlignment: TabAlignment.center,
                    padding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.tab,
                    controller: controller.tabController,
                    labelStyle: TS.bodyMedium,
                    labelColor: black,
                    indicatorColor: black,
                    unselectedLabelColor: greyText,
                    isScrollable: true,
                    tabs: const [
                      Tab(text: 'Headers'),
                      Tab(text: 'Details'),
                      Tab(text: 'Attachment'),
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
            const HeaderDocumentView(),
            const DetailsDocumentView(),
            const AttachmentsView(),
            StatusDocumentView(controller: controller),
          ],
        ),
      ),
    );
  }
}
