import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/status.dart';
import 'package:iroyal/app/modules/detail_tracking_document/views/components/tabs/header.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/views/components/status_approval.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
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
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: white,
              foregroundColor: white,
              surfaceTintColor: white,
              flexibleSpace: EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Text(
                      'Request for man power replacement',
                      style: TS.titleLarge.copyWith(
                        color: black,
                      ),
                    ),
                    15.verticalSpace,
                    SizedBox(
                      width: Get.width,
                      height: 25.h,
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
                  ],
                ),
              ),
              expandedHeight: 150.h,
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
                        controller: controller.tabController,
                        physics: const NeverScrollableScrollPhysics(),
                        labelColor: black,
                        indicatorColor: black,
                        unselectedLabelColor: greyText,
                        isScrollable: false,
                        tabs: const [
                          Tab(text: 'Headers'),
                          Tab(text: 'Details'),
                          Tab(text: 'Attacheds'),
                          Tab(text: 'Status'),
                        ],
                      ),
                    ]),
              ),
            ),
          ],
          body: TabBarView(
            controller: controller.tabController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HeaderView(),
              ComingSoonTabView(),
              ComingSoonTabView(),
              StatusView(),
            ],
          ),
        ),
      ),
    );
  }
}
