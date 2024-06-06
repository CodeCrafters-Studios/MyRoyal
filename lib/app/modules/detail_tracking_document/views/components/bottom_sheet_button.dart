import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';

class BottomSheetButton extends StatelessWidget {
  const BottomSheetButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: white,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ButtonPrimary(
              onPressed: () {},
              key: const Key('rejectBtn'),
              suffixIcon: const Icon(
                Icons.close,
                color: white,
              ),
              text: 'Reject',
              color: Colors.red,
              fullWidth: true,
            ),
          ),
          20.horizontalSpace,
          Expanded(
            child: ButtonPrimary(
              onPressed: () {},
              key: const Key('approveBtn'),
              suffixIcon: const Icon(
                Icons.check,
                color: white,
              ),
              text: 'Approve',
              color: Colors.green,
              fullWidth: true,
            ),
          ),
        ],
      ),
    );
  }
}
