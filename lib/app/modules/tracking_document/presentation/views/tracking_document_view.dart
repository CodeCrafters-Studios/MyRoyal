import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/views/components/approval_view.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/tracking_document_controller.dart';

class TrackingDocumentView extends GetView<TrackingDocumentController> {
  const TrackingDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return TrackingDocumentImplView(controller: controller);
  }
}

class TrackingDocumentImplView extends StatelessWidget {
  final TrackingDocumentController controller;

  const TrackingDocumentImplView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Tracking Document',
      child: Obx(
        () => Column(
          children: [
            const AppbarSpacer(),
            _buildCardApproval(
              title: 'Approval',
              itemCount: controller.trackingDocData.length,
              color: white.withOpacity(0.8),
              onTap: () => Get.to(() => ApprovalView(controller: controller)),
            ),
            15.verticalSpace,
            _buildCardHistory(
              title: 'History',
              itemCount: 0,
              color: white.withOpacity(0.8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardApproval({
    required String title,
    required int itemCount,
    required Color color,
    VoidCallback? onTap,
  }) {
    return controller.isLoading.value
        ? _shimmerCard()
        : CardApp(
            onTap: onTap,
            padding: REdgeInsets.symmetric(vertical: 10),
            width: 335.w,
            borderWidth: 1,
            isShadow: true,
            isOutlined: true,
            shadows: Shadows.universal,
            color: color,
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TS.labelLarge.copyWith(color: black),
                  ),
                  Text(
                    'Number of ${title.toLowerCase()}',
                    style: TS.labelMedium.copyWith(
                      color: greyText,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        itemCount.toString(),
                        style: TS.displayMedium.copyWith(color: primary10),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Items',
                        style: TS.labelMedium.copyWith(
                          color: greyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Row(
                        children: [
                          _statusContainer(
                              icon: Icons.info,
                              label: 'OVERDUE',
                              color: primary50),
                          5.horizontalSpace,
                          Text(
                            '0',
                            style: TS.bodyMedium.copyWith(color: primary50),
                          ),
                        ],
                      ),
                      65.horizontalSpace,
                      Row(
                        children: [
                          _statusContainer(
                              icon: Icons.bolt,
                              label: 'URGENT',
                              color: secondary),
                          5.horizontalSpace,
                          Text(
                            '0',
                            style: TS.bodyMedium.copyWith(color: secondary),
                          ),
                        ],
                      ),
                    ],
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          );
  }

  Widget _buildCardHistory({
    required String title,
    required int itemCount,
    required Color color,
    VoidCallback? onTap,
  }) {
    return controller.isLoading.value
        ? _shimmerCard()
        : CardApp(
            onTap: onTap,
            padding: REdgeInsets.symmetric(vertical: 10),
            width: 335.w,
            borderWidth: 1,
            isShadow: true,
            isOutlined: true,
            shadows: Shadows.universal,
            color: color,
            child: EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TS.labelLarge.copyWith(color: black),
                  ),
                  Text(
                    'Number of ${title.toLowerCase()}',
                    style: TS.labelMedium.copyWith(
                      color: greyText,
                      fontWeight: FontWeight.w400,
                      height: 2,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        itemCount.toString(),
                        style: TS.displayMedium.copyWith(color: primary10),
                      ),
                      10.horizontalSpace,
                      Text(
                        'Items',
                        style: TS.labelMedium.copyWith(
                          color: greyText,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  10.verticalSpace,
                  Row(
                    children: [
                      Row(
                        children: [
                          _statusContainer(
                            icon: Icons.check,
                            label: 'APPROVED',
                            color: green,
                          ),
                          5.horizontalSpace,
                          Text(
                            '0',
                            style: TS.bodyMedium.copyWith(color: green),
                          ),
                        ],
                      ),
                      55.horizontalSpace,
                      Row(
                        children: [
                          _statusContainer(
                            icon: Icons.close,
                            label: 'REJECTED',
                            color: red,
                          ),
                          5.horizontalSpace,
                          Text(
                            '0',
                            style: TS.bodyMedium.copyWith(color: red),
                          ),
                        ],
                      )
                    ],
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          );
  }

  Widget _statusContainer({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: REdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        border: Border.all(color: color),
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(Corners.xll),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20.dm),
          2.horizontalSpace,
          Text(
            label,
            style: TS.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CardApp(
        padding: REdgeInsets.symmetric(vertical: 10),
        height: 180.h,
        width: 335.w,
      ),
    );
  }
}
