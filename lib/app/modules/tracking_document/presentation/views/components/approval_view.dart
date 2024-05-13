import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/controllers/tracking_document_controller.dart';
import 'package:iroyal/app/modules/tracking_document/presentation/views/components/status_approval.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/others/no_result_widget.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

class ApprovalView extends StatelessWidget {
  const ApprovalView({super.key, required this.controller});

  final TrackingDocumentController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Approval',
      textStyle: TS.titleMedium,
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const AppbarSpacer(),
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildInputPrimary(),
            ),
            Obx(
              () => controller.filterDoc.isNotEmpty
                  ? _buildListView()
                  : SizedBox(
                      height: 500.h,
                      child: const NoResultWidget(),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputPrimary() {
    return InputPrimary(
      controller: controller.searchDoc,
      key: const Key('search-trackDoc'),
      label: '',
      hint: 'Search',
      onChanged: controller.onChangedD,
      color: white,
      outlineColor: primary,
      prefixIcon: _buildPrefixIcon(),
    );
  }

  Widget _buildPrefixIcon() {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 20.w,
        height: 20.w,
      ),
    );
  }

  Widget _buildListView() {
    return SearchTextInheritedWidget(
      searchText: RegExp.escape(controller.searchDoc.text),
      child: SizedBox(
        height: Get.height,
        child: ListView.separated(
          separatorBuilder: (_, __) => 15.verticalSpace,
          padding: REdgeInsets.fromLTRB(16, 10, 16, 10),
          itemCount: controller.filterDoc.length,
          itemBuilder: (context, index) {
            final d = controller.filterDoc[index];
            return _buildCard(d);
          },
        ),
      ),
    );
  }

  Widget _buildCard(dynamic d) {
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
            _buildTitleRow(d),
            10.verticalSpace,
            _buildTitleText(d),
            20.verticalSpace,
            _buildStatusList(d),
            20.verticalSpace,
            _buildUserInfoRow(d),
            5.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow(dynamic d) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SearchHighlightText(
            '${d.department.name} - ${d.company.name}',
            style: TS.labelMedium.copyWith(
              color: greyText,
              fontWeight: FontWeight.w400,
              height: 2,
            ),
            highlightStyle: TS.labelLarge.copyWith(color: red),
          ),
          Row(
            children: [
              const Icon(Icons.attach_file, size: 15),
              Text('2', style: TS.bodyLarge),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitleText(dynamic d) {
    return SearchHighlightText(
      d.title,
      style: TS.labelLarge.copyWith(color: black),
      highlightStyle: TS.labelLarge.copyWith(color: red),
    );
  }

  Widget _buildStatusList(dynamic d) {
    return SizedBox(
      width: Get.width,
      height: 25.h,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: controller.listStatus.length,
        itemBuilder: (context, index) {
          final f = controller.listStatus[index];
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
    );
  }

  Widget _buildUserInfoRow(dynamic d) {
    return SizedBox(
      width: Get.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const SizedBox(
                height: 20,
                width: 20,
                child: CircleAvatar(),
              ),
              5.horizontalSpace,
              Text('Anonymous', style: TS.bodySmall.copyWith(color: black)),
            ],
          ),
          SearchHighlightText(
            d.serialNumber,
            style: TS.bodySmall.copyWith(color: black),
            highlightStyle: TS.labelLarge.copyWith(color: red),
          ),
        ],
      ),
    );
  }
}
