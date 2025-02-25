import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

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
                (e) => Padding(
                  padding: REdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: white,
                      border: Border.all(color: primary),
                      borderRadius: Corners.medBorder,
                    ),
                    child: GestureDetector(
                      onTap: () async {
                        controller.launchArticle(e.url);
                      },
                      child: Row(
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            flex: 2,
                            child: ListTile(
                              minVerticalPadding: 0,
                              title: EPadding(
                                padding: const EdgeInsets.only(bottom: 5),
                                child: Text(
                                  e.title,
                                  style: TS.titleSmall,
                                ),
                              ),
                              subtitle: Text(
                                e.subtitle,
                                style: TS.bodySmall,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                                softWrap: true,
                              ),
                            ),
                          ),
                          Flexible(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: Corners.smBorder,
                              child: SizedBox(
                                height: 85.h,
                                width: 85.w,
                                child: FittedBox(
                                  fit: BoxFit.cover,
                                  alignment: FractionalOffset(.5, .0),
                                  child: CachedNetworkImage(
                                    imageUrl: e.imgUrl,
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
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
