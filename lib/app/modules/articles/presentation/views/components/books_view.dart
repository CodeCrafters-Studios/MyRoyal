import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/articles/data/models/books_detail_model.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';

class BooksView extends StatelessWidget {
  BooksView({super.key});

  final BooksDetailModel data = Get.arguments;

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: data.cover.url,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => Container(
                height: 200.h,
                color: grey.withOpacity(0.2),
                child: const Center(
                  child: Icon(Icons.book_rounded, color: grey, size: 50),
                ),
              ),
            ),
            10.verticalSpace,
            EPadding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.name,
                    style: TS.titleMedium,
                  ),
                  10.verticalSpace,
                  Text(
                    DateFormat('dd MMM yyyy').format(data.createdAt),
                    style: TS.labelMedium.copyWith(color: secondary),
                  ),
                  30.verticalSpace,
                  Text(
                    data.description,
                    style: TS.bodyMedium,
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
