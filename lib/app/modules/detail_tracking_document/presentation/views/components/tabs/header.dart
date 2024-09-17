import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/controllers/detail_tracking_document_controller.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/bottom_sheet_button.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class HeaderDocumentView extends StatelessWidget {
  const HeaderDocumentView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Obx(
          () => Padding(
            padding: REdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: controller.isLoading.value
                ? _buildLoadingHeaders()
                : _buildHeaders(),
          ),
        ),
      ),
      bottomSheet: const BottomSheetButton(),
    );
  }

  Widget _buildLoadingHeaders() {
    return Column(
      children: List.generate(11, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: 10.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 5, child: ShimmerText(width: 0)),
              10.horizontalSpace,
              const Expanded(flex: 6, child: ShimmerText(width: 0)),
            ],
          ),
        );
      })
        ..add(Divider(color: Colors.grey.withOpacity(0.2), thickness: 2))
        ..add(10.verticalSpace),
    );
  }

  Widget _buildHeaders() {
    final trackingDocument = controller.trackingDocumentListData;
    final detailPtk = controller.detailTrackingDocDataModel().data.detailPtk;

    return Column(
      children: [
        _buildDetailRow('Posting Date:', trackingDocument.createdAt),
        _buildDetailRow('PTK No:', trackingDocument.serialNumber),
        _buildDetailRow('Labor Quantity:', detailPtk.laborQuantity),
        _buildDetailRow('Position:', trackingDocument.positionName),
        _buildDetailRow('Location:', trackingDocument.locationName),
        _buildDetailRow('Section:', trackingDocument.sectionName),
        _buildDetailRow('Department:', trackingDocument.departmentName),
        _buildDetailRow('Company:', trackingDocument.companyName),
        _buildDetailRow('Status Contract:', detailPtk.employmentStatusesName),
        _buildDetailRow(
            'Status Approval:', detailPtk.state.capitalizeFirst.toString()),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: REdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 5, child: Text(label, style: TS.bodyMedium)),
          Expanded(
            flex: 6,
            child: Text(value,
                style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}
