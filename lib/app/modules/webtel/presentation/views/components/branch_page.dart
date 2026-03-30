import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/webtel/presentation/controllers/webtel_controller.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/app_divider.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/others/no_result_widget.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';
import 'package:search_highlight_text/search_highlight_text.dart';

class BranchPage extends StatelessWidget {
  const BranchPage({
    super.key,
    required this.title,
    required this.controller,
    required this.data,
  });

  final String title;
  final List data;
  final WebtelController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: title,
      textStyle: TS.titleSmall.copyWith(color: white),
      iconColor: white,
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
              () => data.isNotEmpty
                  ? SearchTextInheritedWidget(
                      searchText: RegExp.escape(_getSearchController().text),
                      child: SizedBox(
                        height: Get.height,
                        child: _buildListView(data),
                      ),
                    )
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
    return Obx(
      () => InputPrimary(
        controller: _getSearchController(),
        key: _getSearchKey(),
        label: '',
        hint: 'Search',
        onChanged: _getOnChangedCallback(),
        color: white,
        outlineColor: primary,
        prefixIcon: _buildPrefixIcon(),
        suffixIcon: _buildSuffixIcon(),
      ),
    );
  }

  Widget _buildListView(List data) {
    return Obx(
      () => data.isNotEmpty
          ? SizedBox(
              height: Get.height,
              child: RepaintBoundary(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const IntrinsicHeight(
                    child: EPadding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: AppDivider(
                        color: black,
                      ),
                    ),
                  ),
                  padding: REdgeInsets.only(top: 5, bottom: 150.h),
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final d = data[index];

                    return EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListTile(
                        title: SearchHighlightText(
                          d.fullName,
                          softWrap: true,
                          style: TS.labelLarge.copyWith(color: black),
                          highlightStyle: TS.labelLarge.copyWith(color: red),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            d.workEmail != '' || d.workEmail.isNull
                                ? SearchHighlightText(
                                    d.workEmail,
                                    softWrap: true,
                                    style: TS.bodyMedium.copyWith(color: black),
                                    highlightStyle:
                                        TS.bodyMedium.copyWith(color: red),
                                  )
                                : Text(
                                    "-",
                                    softWrap: true,
                                    style: TS.bodyMedium.copyWith(color: black),
                                  ),
                            10.verticalSpace,
                            SearchHighlightText(
                              d.departmentName,
                              softWrap: true,
                              style: TS.labelLarge.copyWith(color: black),
                              highlightStyle:
                                  TS.labelLarge.copyWith(color: red),
                            ),
                          ],
                        ),
                        trailing: SearchHighlightText(
                          d.extentionNumber.toString(),
                          softWrap: true,
                          style: TS.titleMedium.copyWith(color: black),
                          highlightStyle: TS.titleMedium.copyWith(color: red),
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : SizedBox(
              height: 500.h,
              child: const NoResultWidget(),
            ),
    );
  }

  TextEditingController _getSearchController() {
    if (title == 'PT Royal Abadi Sejahtera') {
      return controller.searchR;
    } else if (title == 'PT Bestari Mulia') {
      return controller.searchB;
    } else if (title == 'PT ACA') {
      return controller.searchA;
    } else if (title == 'PT BCP') {
      return controller.searchBC;
    } else {
      return controller.searchC;
    }
  }

  Key _getSearchKey() {
    if (title == 'PT Royal Abadi Sejahtera') {
      return const Key('search-RasBranch');
    } else if (title == 'PT Bestari Mulia') {
      return const Key('search-BmBranch');
    } else if (title == 'PT ACA') {
      return const Key('search-AcaBranch');
    } else if (title == 'PT BCP') {
      return const Key('search-BcpBranch');
    } else {
      return const Key('search-CamBranch');
    }
  }

  Function(String) _getOnChangedCallback() {
    if (title == 'PT Royal Abadi Sejahtera') {
      return controller.onChangedR;
    } else if (title == 'PT Bestari Mulia') {
      return controller.onChangedB;
    } else if (title == 'PT ACA') {
      return controller.onChangedA;
    } else if (title == 'PT BCP') {
      return controller.onChangedBC;
    } else {
      return controller.onChangedC;
    }
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
