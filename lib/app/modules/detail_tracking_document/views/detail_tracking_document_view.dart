import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/attachments.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/details.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/status.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/header.dart';
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
    return GetBuilder<DetailTrackingDocumentController>(
      builder: (controller) => Scaffold(
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
                    SizedBox(
                      width: Get.width,
                      height: 30.h,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.statusApproval.length,
                        itemBuilder: (context, index) {
                          final f = controller.statusApproval[index];
                          return StatusApproval(
                            borderColor: f.borderColor,
                            decorationColor: f.decorationColor,
                            icon: f.icon,
                            iconColor: f.iconColor,
                            status: f.status,
                            statusColor: f.statusColor,
                            isIcon: f.isIcon,
                          );
                        },
                      ),
                    ),
                    5.verticalSpace,
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
      ),
    );
  }
}
