import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/page_base.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
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

class ComingSoonTabView extends StatelessWidget {
  const ComingSoonTabView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
    );
  }
}
