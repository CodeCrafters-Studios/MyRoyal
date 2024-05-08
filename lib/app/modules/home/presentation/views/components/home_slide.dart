import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';

class HomeSlide extends StatelessWidget {
  const HomeSlide({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: CardApp(
        width: Get.width,
        height: 255.h,
        padding: REdgeInsets.symmetric(vertical: 20),
        isShadow: false,
        shadows: Shadows.universal,
        child: Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CarouselSlider(
                items: controller.homeSLider
                    .map(
                      (e) => Padding(
                        padding: REdgeInsets.symmetric(horizontal: 6),
                        child: ClipRRect(
                          borderRadius: Corners.medBorder,
                          child: CachedNetworkImage(
                            // imageUrl:
                            //     AppConfig.environment.baseUrl + e.image,
                            imageUrl:
                                'https://images.unsplash.com/photo-1505693416388-ac5ce068fe85?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
                            width: Get.width * .9,
                            height: 132.h,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    )
                    .toList(),
                options: CarouselOptions(
                  autoPlay: true,
                  viewportFraction: 0.9,
                  height: 132.h,
                  onPageChanged: (index, reason) =>
                      controller.indexSlider(index),
                ),
              ),
              10.verticalSpace,
              CarouselIndicator(
                activeColor: primary,
                color: grey,
                count: controller.homeSLider.length,
                index: controller.indexSlider(),
                width: 8,
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
