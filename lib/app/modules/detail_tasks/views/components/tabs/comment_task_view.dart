import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

class CommentTaskView extends StatelessWidget {
  const CommentTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: white,
      body: SizedBox(
        height: Get.height,
        child: ListView.builder(
          padding: REdgeInsets.only(bottom: 50),
          itemCount: 10,
          itemBuilder: (_, __) {
            return SizedBox(
              height: 170.h,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: REdgeInsets.symmetric(horizontal: 5),
                    leading: CircleAvatar(
                      radius: 20.r,
                    ),
                    title: Text(
                      'Anonymous',
                      style: TS.bodyMedium,
                    ),
                    subtitle: Text(
                      'Project Manager',
                      style: TS.bodySmall.copyWith(fontWeight: FontWeight.w400),
                    ),
                    trailing: Text(
                      '1 mins ago',
                      style: TS.caption.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  10.verticalSpace,
                  EPadding(
                    padding: const EdgeInsets.only(left: 60, right: 20),
                    child: Text(
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt',
                      style: TS.bodyMedium,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      bottomSheet: SizedBox(
        height: 60.h,
        child: Material(
          color: white,
          child: InputPrimary(
            margin: REdgeInsets.only(top: 5, bottom: 5),
            key: const Key('inputComment'),
            hint: 'type here...',
            suffixIcon: const Icon(
              Icons.send,
              color: primary,
            ),
          ),
        ),
      ),
    );
  }
}
