import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/presentation/controllers/home_controller.dart';
import 'package:iroyal/app/modules/home/presentation/views/components/home_user_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';

class HomeUserStatus extends GetView<HomeController> {
  const HomeUserStatus({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: EPadding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Activity for Today",
                  style: TS.titleMedium,
                ),
              ],
            ),
            20.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CardApp(
                  color: primary.withOpacity(0.8),
                  outlineColor: black,
                  child: const HomeUserCard(
                    shapeBorder: true,
                    isAvatarPicture: false,
                    title: 'Yesterday Clock-in',
                    subtitle: '00:00:00',
                    isThridLine: false,
                    textColor: white,
                    backgroundColor: white,
                    borderSideColor: greyHint,
                    suffixIcon: false,
                  ),
                ),
                const CardApp(
                  color: grey,
                  outlineColor: black,
                  child: HomeUserCard(
                    shapeBorder: true,
                    isAvatarPicture: false,
                    title: 'Yesterday Clock-out',
                    subtitle: '00:00:00',
                    isThridLine: false,
                    textColor: black,
                    backgroundColor: white,
                    borderSideColor: greyHint,
                    suffixIcon: false,
                  ),
                ),
              ],
            ),
            10.verticalSpace
          ],
        ),
      ),
    );
  }
}
