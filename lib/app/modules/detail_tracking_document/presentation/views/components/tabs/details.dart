import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/detail_tracking_document/presentation/controllers/detail_tracking_document_controller.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class DetailsDocumentView extends StatelessWidget {
  const DetailsDocumentView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Obx(
          () => controller.isLoading.value
              ? _buildLoadingDetails()
              : _buildDetails(),
        ),
      ),
    );
  }

  Widget _buildLoadingDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        ShimmerText(width: 120.w),
        20.verticalSpace,
        ShimmerText(
          width: Get.width,
          height: 150.h,
        ),
        20.verticalSpace,
        ShimmerText(width: 120.w),
        20.verticalSpace,
        ShimmerText(
          width: Get.width,
          height: 150.h,
        ),
        20.verticalSpace,
        ShimmerText(width: 120.w),
        20.verticalSpace,
        ShimmerText(
          width: Get.width,
          height: 150.h,
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        20.verticalSpace,
        Text(
          'Persyaratan:',
          style: TS.bodyLarge,
        ),
        20.verticalSpace,
        Text(
          controller.detailTrackingDocDataModel().data.detailPtk.requirement,
          style: TS.bodyMedium,
        ),
        20.verticalSpace,
        Text(
          'Deskripsi:',
          style: TS.bodyLarge,
        ),
        20.verticalSpace,
        Text(
          controller
              .detailTrackingDocDataModel()
              .data
              .detailPtk
              .reasonDescription,
          style: TS.bodyMedium,
        ),
        20.verticalSpace,
        Text(
          'Deskripsi Pekerjaan:',
          style: TS.bodyLarge,
        ),
        20.verticalSpace,
        Text(
          controller
              .detailTrackingDocDataModel()
              .data
              .detailPtk
              .reasonDescription,
          style: TS.bodyMedium,
        )
      ],
    );
  }
}
