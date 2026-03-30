import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:MyRoyal/app/modules/tracking_document/presentation/views/components/status_approval.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/others/empty_data_widget.dart';
import 'package:MyRoyal/base/widgets/others/no_result_widget.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';
import 'package:shimmer/shimmer.dart';

class HistoryView extends StatelessWidget {
  const HistoryView({super.key, required this.controller});

  final TrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'History',
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppbarSpacer(),
            _buildSearchBar(),
            Obx(() => controller.isLoading.value
                ? _buildLoadingDocumentList()
                : controller.listDataHistory.isEmpty
                    ? const EmptyDataWidget()
                    : controller.filterDataHistory.isEmpty
                        ? SizedBox(height: 500.h, child: const NoResultWidget())
                        : _buildDocumentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingDocumentList() {
    return SizedBox(
      height: Get.height,
      child: ListView.separated(
        separatorBuilder: (_, __) => 15.verticalSpace,
        padding: REdgeInsets.fromLTRB(16, 10, 16, 180),
        itemCount: 10,
        itemBuilder: (_, __) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: CardApp(
              height: 150.h,
              onTap: null,
              width: 335.w,
              child: emptyBox,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InputPrimary(
        controller: controller.searchDocHistory,
        key: const Key('search-trackDocHistory'),
        label: '',
        hint: 'Search',
        onChanged: controller.onSearchChangedOnHistory,
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
    return Obx(
      () => RefreshIndicator(
        backgroundColor: white,
        color: primary,
        onRefresh: controller.onRefresh,
        child: SizedBox(
          height: Get.height,
          child: RepaintBoundary(
            child: ListView.separated(
              separatorBuilder: (_, __) => 15.verticalSpace,
              padding: REdgeInsets.fromLTRB(16, 10, 16, 180),
              itemCount: controller.filterDataHistory.length,
              itemBuilder: (context, index) {
                final doc = controller.filterDataHistory[index];
                return controller.filterDataHistory.isEmpty
                    ? SizedBox(height: 500.h, child: const NoResultWidget())
                    : SearchTextInheritedWidget(
                        searchText:
                            RegExp.escape(controller.searchDocHistory.text),
                        child: _buildDocumentCard(doc));
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentCard(dynamic doc) {
    return CardApp(
      onTap: () => Get.toNamed(
        Routes.DETAIL_TRACKING_DOCUMENT,
        arguments: doc,
      ),
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
    final String status = doc.state.toUpperCase();
    final bool isApproved = doc.state == 'Approved';
    final bool isRejected = doc.state == 'Rejected';
    final Color color = isApproved
        ? green
        : isRejected
            ? red
            : greyText;
    final IconData icon = isApproved
        ? Icons.check
        : isRejected
            ? Icons.close
            : Icons.block;

    return StatusApproval(
      borderColor: color,
      decorationColor: color,
      icon: icon,
      iconColor: color,
      status: status,
      statusColor: color,
    );
  }

  Widget _buildLastApprovalInfo(dynamic doc) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Last Approval By: ', style: TS.bodySmall.copyWith(color: black)),
        Flexible(
          fit: FlexFit.loose,
          child: SearchHighlightText(
            doc.lastApprovalBy,
            style: TS.bodySmall,
            highlightStyle: TS.labelLarge,
            softWrap: false,
            overflow: TextOverflow.fade,
          ),
        ),
      ],
    );
  }
}
