import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({
    super.key,
    required this.menu,
  });
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: () {
        switch (menu.name) {
          case 'My Teams':
            Get.toNamed(Routes.MY_TEAMS);
            break;
          case 'Webtel':
            Get.toNamed(Routes.WEBTEL);
            break;
          case 'Tracking Documents':
            Get.toNamed(Routes.TRACKING_DOCUMENT);
            break;
          case 'Tasks':
            Get.toNamed(Routes.TASKS);
            break;
          default:
            Get.to(() => const ComingSoonScreen());
            break;
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 54.h,
            padding: REdgeInsets.all(4),
            child: Center(
              child: Image.asset(
                'assets/icons/${menu.code}.png',
              ),
            ),
          ),
          4.verticalSpace,
          Text(
            menu.name,
            textAlign: TextAlign.center,
            style: TS.caption,
          ),
        ],
      ),
    );
  }
}
