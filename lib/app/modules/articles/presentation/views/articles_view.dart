import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/app/modules/articles/presentation/views/components/recommendation_book_card.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

import '../controllers/articles_controller.dart';

class ArticlesView extends GetView<ArticlesController> {
  const ArticlesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Get.back(),
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18.w,
              color: secondary,
            ),
          ),
        ),
        body: ArticlesViewImpl(controller: controller));
  }
}

class ArticlesViewImpl extends StatelessWidget {
  const ArticlesViewImpl({
    super.key,
    required this.controller,
  });

  final ArticlesController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => controller.isLoading.value ? _loadingArticles() : _buildArticles(),
    );
  }

  Widget _loadingArticles() {
    return SingleChildScrollView(
      child: Column(
        children: [
          ShimmerText(
            width: Get.width,
            height: 250.h,
          ),
          10.verticalSpace,
          EPadding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerText(width: 100.w),
                10.verticalSpace,
                ShimmerText(width: Get.width),
                30.verticalSpace,
                ShimmerText(
                  width: Get.width,
                  height: 200.h,
                ),
                10.verticalSpace,
                Divider(
                  color: greyHint,
                  thickness: 0.5,
                ),
                20.verticalSpace,
                ShimmerText(width: 100.w),
                5.verticalSpace,
                SizedBox(
                  height: 400.h,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: 2,
                    separatorBuilder: (_, __) => Divider(
                      color: greyHint,
                      thickness: 0.3,
                    ),
                    itemBuilder: (_, __) {
                      return ShimmerText(
                        width: 50.w,
                        height: 80.h,
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildArticles() {
    return SingleChildScrollView(
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: controller.dataArticle.imgUrl,
            width: Get.width,
            height: 250.h,
            fit: BoxFit.cover,
          ),
          10.verticalSpace,
          EPadding(
            padding: EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.dataArticle.title,
                  style: TS.titleMedium,
                ),
                10.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'By ${controller.dataArticleDetail.value.createdBy.name}',
                      style: TS.labelMedium.copyWith(color: secondary),
                    ),
                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(controller.dataArticleDetail.value.createdAt),
                      style: TS.labelMedium.copyWith(color: secondary),
                    ),
                  ],
                ),
                30.verticalSpace,
                Text(
                  controller.dataArticleDetail.value.description,
                  style: TS.bodyMedium,
                  textAlign: TextAlign.justify,
                ),
                10.verticalSpace,
                Divider(
                  color: greyHint,
                  thickness: 0.5,
                ),
                20.verticalSpace,
                Text(
                  'Rekomendasi Buku',
                  style: TS.titleMedium,
                ),
                5.verticalSpace,
                SizedBox(
                  height: controller.dataArticleDetail.value.books.length > 3
                      ? 400.h
                      : 300.h,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: controller.dataArticleDetail.value.books.length,
                    separatorBuilder: (_, __) => Divider(
                      color: greyHint,
                      thickness: 0.3,
                    ),
                    itemBuilder: (context, index) {
                      final data =
                          controller.dataArticleDetail.value.books[index];
                      return RecommendationBookCard(
                          title: data.name,
                          description: data.description,
                          createdAt: data.createdAt,
                          onTap: () async {
                            await controller.getDetailBooks(
                              data.id.toString(),
                            );
                          });
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
