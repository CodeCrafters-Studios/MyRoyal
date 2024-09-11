import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/views/components/status_approval.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/design/colors.dart';

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key, required this.controller});

  final TrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Approval',
      textStyle: TS.titleMedium,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppbarSpacer(),
            _buildSearchBar(),
            Obx(() => controller.filterData.isEmpty
                ? SizedBox(height: 500.h, child: const NoResultWidget())
                : _buildDocumentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputPrimary(
        controller: controller.searchDoc,
        key: const Key('search-trackDoc'),
        label: '',
        hint: 'Search',
        onChanged: controller.onSearchChanged,
        color: white,
        outlineColor: primary,
        prefixIcon: _buildSearchIcon(),
      ),
    );
  }

  Widget _buildSearchIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  Widget _buildDocumentList() {
    return Obx(() => SizedBox(
          height: Get.height,
          child: ListView.separated(
            separatorBuilder: (_, __) => 15.verticalSpace,
            padding: REdgeInsets.symmetric(horizontal: 16, vertical: 10),
            itemCount: controller.filterData.length,
            itemBuilder: (context, index) {
              final doc = controller.filterData[index];
              return SearchTextInheritedWidget(
                  searchText: RegExp.escape(controller.searchDoc.text),
                  child: _buildDocumentCard(doc));
            },
          ),
        ));
  }

  Widget _buildDocumentCard(dynamic doc) {
    return CardApp(
      onTap: () => Get.toNamed(Routes.DETAIL_TRACKING_DOCUMENT),
      padding: REdgeInsets.symmetric(vertical: 10),
      width: 335.w,
      borderWidth: 1,
      isShadow: true,
      isOutlined: true,
      shadows: Shadows.universal,
      color: white.withOpacity(0.8),
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildInfoRow(doc.serialNumber, doc.createdAt),
            10.verticalSpace,
            _buildInfoText('${doc.departmentName} - ${doc.companyName}'),
            10.verticalSpace,
            _buildInfoText('${doc.title} ${doc.locationName}'),
            20.verticalSpace,
            _buildStatus(doc),
            20.verticalSpace,
            _buildLastApprovalInfo(doc),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String serialNumber, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SearchHighlightText(
          serialNumber,
          style:
              TS.labelLarge.copyWith(color: black, fontWeight: FontWeight.bold),
          highlightStyle: TS.labelLarge.copyWith(color: red),
        ),
        SearchHighlightText(
          date,
          style: TS.labelMedium
              .copyWith(color: black, fontWeight: FontWeight.w500),
          highlightStyle: TS.labelLarge.copyWith(color: red),
        ),
      ],
    );
  }

  Widget _buildInfoText(String text) {
    return SearchHighlightText(
      text,
      style:
          TS.labelMedium.copyWith(color: greyText, fontWeight: FontWeight.w400),
      highlightStyle: TS.labelLarge.copyWith(color: red),
    );
  }

  Widget _buildStatus(dynamic doc) {
    final isOnTime = doc.stateTargetCompletionDate == 'On Time';
    final isUrgent = doc.stateTargetCompletionDate == 'Urgent';
    final color = isOnTime ? primary50 : (isUrgent ? urgentColor : red);

    return StatusApproval(
      borderColor: color,
      decorationColor: color,
      icon: isOnTime ? Icons.info : (isUrgent ? Icons.bolt : Icons.warning),
      iconColor: color,
      status: doc.stateTargetCompletionDate.toUpperCase(),
      statusColor: color,
    );
  }

  Widget _buildLastApprovalInfo(dynamic doc) {
    return Row(
      children: [
        Text('Last Approval By:', style: TS.bodySmall.copyWith(color: black)),
        5.horizontalSpace,
        SearchHighlightText(
          doc.lastApprovalBy,
          style: TS.bodySmall.copyWith(color: black),
          highlightStyle: TS.labelLarge.copyWith(color: red),
        ),
      ],
    );
  }
}
