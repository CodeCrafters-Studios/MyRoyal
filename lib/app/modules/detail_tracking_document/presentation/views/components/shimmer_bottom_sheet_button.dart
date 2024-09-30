import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBottomSheetButton extends StatelessWidget {
  const ShimmerBottomSheetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: greyIcon,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Expanded(
              child: ButtonPrimary(
                onPressed: null,
                text: '',
                fullWidth: true,
              ),
            ),
            20.horizontalSpace,
            const Expanded(
              child: ButtonPrimary(
                onPressed: null,
                text: '',
                fullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
