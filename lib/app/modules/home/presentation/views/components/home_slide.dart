import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/articles/presentation/views/components/articles_card.dart';
import 'package:MyRoyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class HomeSlide extends StatelessWidget {
  const HomeSlide({super.key, required this.controller});
  final HomeController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SliverToBoxAdapter(
          child: controller.isLoading.value
              ? _loadingArticles()
              : _buildArticles()),
    );
  }

  Widget _loadingArticles() {
    return Column(
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
    );
  }

  Widget _buildArticles() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        EPadding(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          child: Text(
            'Royal Wiki',
            style: TS.titleMedium,
            textAlign: TextAlign.start,
          ),
        ),
        10.verticalSpace,
        CarouselSlider(
          items: controller.homeSlider
              .map(
                (e) => ArticlesCard(
                  title: e.title,
                  subtitle: e.subtitle,
                  imgUrl: e.imgUrl,
                  onTap: () => Get.toNamed(Routes.ARTICLES, arguments: e),
                ),
              )
              .toList(),
          options: CarouselOptions(
            autoPlay: true,
            viewportFraction: 0.9,
            height: 132.h,
            // onPageChanged: (index, reason) =>
            //     controller.indexSlider(index),
          ),
        ),
        Container(
          height: 100.h,
        ),
      ],
    );
  }
}
