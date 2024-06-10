import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_divider.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/visit_controller.dart';

class VisitView extends GetView<VisitController> {
  const VisitView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      title: 'Visit',
      showBackground: false,
      child: Stack(
        children: [
          Column(
            children: [
              const AppbarSpacer(),
              Obx(
                () {
                  if (controller.currentPosition.value == null) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return SizedBox(
                    height: 300.h,
                    child: GoogleMap(
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                      initialCameraPosition: CameraPosition(
                        target: controller.currentPosition.value!,
                        zoom: 18,
                      ),
                      onMapCreated: controller.onMapCreated,
                      markers: controller.markers.toSet(),
                    ),
                  );
                },
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                ),
              ),
              height: 420.h,
              width: Get.width,
              child: EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  children: [
                    15.verticalSpace,
                    Container(
                      height: 5.h,
                      width: 70.w,
                      decoration: BoxDecoration(
                        color: grey.withOpacity(0.8),
                        borderRadius: BorderRadius.all(
                          Radius.circular(21.r),
                        ),
                      ),
                    ),
                    15.verticalSpace,
                    InputPrimary(
                      // controller: _getSearchController(),
                      // key: _getSearchKey(),
                      label: '',
                      hint: 'Search',
                      onChanged: (value) {},
                      color: white,
                      outlineColor: primary,
                      prefixIcon: _buildPrefixIcon(),
                      suffixIcon: _buildSuffixIcon(),
                    ),
                    10.verticalSpace,
                    Obx(
                      () => Expanded(
                        child: SizedBox(
                          height: Get.height,
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            separatorBuilder: (context, index) {
                              return const AppDivider();
                            },
                            itemCount: controller.locationsData.length,
                            itemBuilder: (ctx, index) {
                              final data = controller.locationsData[index];
                              final getIndex = index;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data.name,
                                    style: TS.bodyLarge,
                                  ),
                                  10.verticalSpace,
                                  InkWellTap(
                                    onTap: () {
                                      if (getIndex == index) {
                                        controller.setLocation(
                                          data.lat,
                                          data.long,
                                          index,
                                        );
                                      }
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(
                                        data.address,
                                        style: TS.bodyMedium.copyWith(),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          10.verticalSpace,
                                          Text(
                                            data.phone,
                                            style: TS.bodyMedium.copyWith(
                                                fontWeight: FontWeight.w400),
                                          ),
                                        ],
                                      ),
                                      trailing: IconButton(
                                        onPressed: () {},
                                        icon: Icon(
                                          Icons.arrow_forward_ios,
                                          size: 24.r,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
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
