import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/approval/presentation/views/components/all_approval_request_view.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

import '../controllers/approval_controller.dart';

class ApprovalView extends GetView<ApprovalController> {
  const ApprovalView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Approval',
      showBackground: false,
      child: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            AppbarSpacer(),
            _buildSearch(),
            AllApprovalRequestView(controller: controller),
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() {
    return Obx(
      () => EPadding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: InputPrimary(
          controller: controller.search,
          label: '',
          hint: 'Search',
          onChanged: controller.onChanged,
          color: white,
          outlineColor: primary,
          prefixIcon: _buildPrefixIcon(),
          suffixIcon: _buildSuffixIcon(),
        ),
      ),
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

  Widget? _buildSuffixIcon() {
    final valueListener = controller.valueListener.value;
    return valueListener.isNotEmpty
        ? IconButton(
            onPressed: controller.clear,
            icon: const Icon(Icons.clear),
          )
        : null;
  }
}
