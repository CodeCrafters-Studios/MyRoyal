import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iroyal/app/modules/home/domain/entities/menu.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class HomeIconMenu extends StatelessWidget {
  const HomeIconMenu({
    super.key,
    required this.menu,
  });
  final Menu menu;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: () {
        // switch (menu.code) {
        //   case 'my-teams':
        //     Get.toNamed(Routes.MY_TEAMS);
        //     break;
        //   default:
        //     break;
        // }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            padding: REdgeInsets.all(8),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x0C555555),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: SvgPicture.asset(
              'assets/icons/${menu.code}.svg',
              width: 32.w,
              height: 32.w,
              color: primary,
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
