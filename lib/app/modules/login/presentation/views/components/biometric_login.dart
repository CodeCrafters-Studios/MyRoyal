import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class BiometricsLogin extends StatelessWidget {
  const BiometricsLogin({super.key, required this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: Image.asset(
        'assets/icons/ic_fingerprint.png',
        width: 42.w,
        height: 42.h,
      ),

      //  Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Image.asset(
      //       'assets/icons/ic_fingerprint.png',
      //       width: 42.w,
      //       height: 42.h,
      //     ),
      //     Container(
      //       height: 56.h,
      //       width: 1,
      //       color: Colors.black,
      //       margin: REdgeInsets.symmetric(horizontal: 16),
      //     ),
      //     Image.asset(
      //       'assets/icons/ic_face_id.png',
      //       width: 42.w,
      //       height: 42.h,
      //     ),
      //   ],
      // ),
    );
  }
}
