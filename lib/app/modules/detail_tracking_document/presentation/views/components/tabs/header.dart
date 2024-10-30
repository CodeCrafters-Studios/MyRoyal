import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/controllers/detail_tracking_document_controller.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/bottom_sheet_button.dart';
import 'package:iroyal/app/modules/detail_tracking_document/presentation/views/components/shimmer_bottom_sheet_button.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

class HeaderDocumentView extends StatelessWidget {
  const HeaderDocumentView({super.key, required this.controller});

  final DetailTrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    final trackingDocument = controller.trackingDocumentListData;

    return Obx(
      () => Scaffold(
        backgroundColor: white,
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Padding(
            padding: REdgeInsets.symmetric(horizontal: 18, vertical: 15),
            child: controller.isLoading.value
                ? _buildLoadingHeaders()
                : _buildHeaders(),
          ),
        ),
        bottomSheet: controller.isLoading.value
            ? const ShimmerBottomSheetButton()
            : trackingDocument.needApproval
                ? BottomSheetButton(
                    onTapRejcet: () => AppDialogImpl().showChoiceDialog(
                          title: 'Confirmation',
                          description:
                              'Are you sure want to reject this document?',
                          onPressedYes: () {
                            AppUtils.logApp('HERE');
                            Get.dialog(
                              Dialog(
                                insetPadding:
                                    REdgeInsets.symmetric(horizontal: 40),
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(
                                    Insets.xl,
                                    Insets.xl,
                                    Insets.xl,
                                    Insets.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: Corners.smBorder,
                                    color: Colors.white,
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Reason',
                                        style: TS.titleMedium,
                                        textAlign: TextAlign.center,
                                      ),
                                      20.verticalSpace,
                                      InputPrimary(
                                        controller: controller.reason,
                                        maxLength: 1000,
                                        maxLines: 5,
                                        color: white,
                                        outlineColor: primary,
                                        hint: 'Type here..',
                                        validation: (value) =>
                                            value?.isEmpty ?? false
                                                ? 'Cannot be empty'
                                                : null,
                                        onChanged: (value) {
                                          controller.reasonText.value = value;
                                          AppUtils.logApp(
                                              controller.reasonText.value);
                                        },
                                      ),
                                      28.verticalSpace,
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ButtonPrimary(
                                              onPressed: () => Get.back(),
                                              text: 'Cancel',
                                              color: redPrimary,
                                              fullWidth: true,
                                            ),
                                          ),
                                          12.horizontalSpace,
                                          Obx(
                                            () => Expanded(
                                              child: ButtonPrimary(
                                                enable: controller.reasonText
                                                    .value.isNotEmpty,
                                                onPressed: () {
                                                  AppUtils.logApp(controller
                                                      .reasonText.value);
                                                  Get.back();
                                                  Get.back();
                                                  controller.postActionDocument(
                                                    trackingDocument.id,
                                                    'reject',
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
                              barrierDismissible: false,
                            );
                          },
                        ),
                    onTapApprove: () => AppDialogImpl().showChoiceDialog(
                        title: 'Confirmation',
                        description:
                            'Are you sure want to approve this document?',
                        onPressedYes: () {
                          Get.back();
                          controller.postActionDocument(
                            trackingDocument.id,
                            'approve',
                            '',
                          );
                        }))
                : null,
      ),
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

    return SizedBox(
      height: Get.height,
      child: Column(
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
      ),
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
