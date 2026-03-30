import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      showIconBack: false,
      centeredTitle: true,
      textStyle: TS.headlineSmall.copyWith(color: white),
      title: 'Coming Soon',
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: 280.h,
            width: 280.w,
            child: Image.asset('assets/images/img_coming_soon.png'),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 14),
            child: Text(
              "Great things Coming Soon.",
              style: TS.titleLarge,
            ),
          ),
          Padding(
            padding: REdgeInsets.symmetric(horizontal: 8),
            child: Text(
              "We're working hard to bring you something amazing.\nStay tuned.",
              style: TS.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
