import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/settings/presentation/views/components/item_menu_settings.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_default.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/webtel_controller.dart';

class WebtelView extends GetView<WebtelController> {
  const WebtelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: InkWellTap(
          onTap: Get.back,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.w,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
        title: Text(
          'Webtel',
          style: TS.titleSmall,
          textAlign: TextAlign.start,
        ),
        backgroundColor: bgColor.withOpacity(.7),
        surfaceTintColor: Colors.transparent,
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: bgColor.withOpacity(.7),
            surfaceTintColor: Colors.transparent,
            pinned: true,
            automaticallyImplyLeading: false,
            expandedHeight: 70.h,
            flexibleSpace: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: InputPrimary(
                key: const Key('searchWebtel'),
                label: '',
                hint: 'Search',
                onChanged: (_) {},
                color: white,
                outlineColor: primary,
                prefixIcon: EPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: SvgPicture.asset(
                    'assets/icons/ic_search.svg',
                    width: 20.w,
                    height: 20.w,
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PT RAS',
                    style: TS.titleMedium,
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final data = controller.listData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          5.horizontalSpace,
                          Text(
                            data.ext.toString(),
                            style: TS.bodySmall,
                          ),
                          30.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.fullname,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                          25.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.departmentName,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      const Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
              childCount: controller.listData.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Text(
                    'PT BM',
                    style: TS.titleMedium,
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final data = controller.listData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          5.horizontalSpace,
                          Text(
                            data.ext.toString(),
                            style: TS.bodySmall,
                          ),
                          30.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.fullname,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                          25.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.departmentName,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      const Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
              childCount: controller.listData.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Text(
                    'PT ACA',
                    style: TS.titleMedium,
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                final data = controller.listData[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          5.horizontalSpace,
                          Text(
                            data.ext.toString(),
                            style: TS.bodySmall,
                          ),
                          30.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.fullname,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                          25.horizontalSpace,
                          Expanded(
                            child: Text(
                              data.departmentName,
                              softWrap: true,
                              style: TS.labelMedium,
                            ),
                          ),
                        ],
                      ),
                      5.verticalSpace,
                      const Divider(color: Colors.grey),
                    ],
                  ),
                );
              },
              childCount: controller.listData.length,
            ),
          ),
        ],
      ),
    );
  }
}
