import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:MyRoyal/base/design/styles.dart';

class OnlineAppIcon extends StatelessWidget {
  const OnlineAppIcon({
    super.key,
    this.onTap,
    required this.imgUrl,
    required this.title,
  });

  final void Function()? onTap;
  final String imgUrl, title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 54.h,
            padding: REdgeInsets.all(4),
            child: Center(
              child: SvgPicture.asset(imgUrl),
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TS.caption,
          ),
        ],
      ),
    );
  }
}
