import 'package:MyRoyal/base/design/colors.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/articles/presentation/views/components/articles_card.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:shimmer/shimmer.dart';

class HomeSlide extends StatelessWidget {
  const HomeSlide({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverToBoxAdapter(
        child:
            controller.isLoading.value ? _loadingArticles() : _buildArticles(),
      ),
    );
  }

  Widget _loadingArticles() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 16, 0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: ShimmerText(
                  width: 150.w,
                ),
              ),
            ),
            ShimmerText(
              width: Get.width * .9,
              height: 132.h,
            ),
            Container(
              height: 100.h,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticles() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
          child: Row(
            children: [
              Container(
                width: 3.w,
                height: 16.h,
                decoration: BoxDecoration(
                  gradient: Gradients.primary(),
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
              8.horizontalSpace,
              Text(
                'Promosi',
                style: TS.titleSmall.copyWith(color: primary),
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
        10.verticalSpace,
        CarouselSlider.builder(
          itemCount: controller.homeSlider.length,
          itemBuilder: (context, index, realIndex) {
            final e = controller.homeSlider[index];
            return BannerCard(
              imgUrl: e.img,
              onTap: () {},
            );
          },
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.95,
            height: 132.h,
            // onPageChanged: (index, reason) =>
            //     controller.indexSlider(index),
          ),
        ),
        120.verticalSpace,
      ],
    );
  }
}
