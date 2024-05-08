import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:shimmer/shimmer.dart';

class LoadingMainMenu extends StatelessWidget {
  const LoadingMainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final list = List<int>.generate(8, (index) => 1);
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: CardApp(
        width: Get.width,
        height: 200.h,
        padding: REdgeInsets.all(14),
        child: GridView.count(
          padding: EdgeInsets.zero,
          mainAxisSpacing: 15.w,
          crossAxisSpacing: 28.w,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          shrinkWrap: true,
          children: list
              .map(
                (e) => CardApp(
                  width: 48.w,
                  height: 48.w,
                  color: grey.withOpacity(.5),
                  radius: 10,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
