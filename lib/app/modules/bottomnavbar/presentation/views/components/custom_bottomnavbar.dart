import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class CustomButtomBar extends StatelessWidget {
  const CustomButtomBar({
    super.key,
    required this.listBottomNav,
  });

  final List<Widget> listBottomNav;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      radius: 30,
      isShadow: true,
      shadows: Shadows.universal,
      margin: REdgeInsets.symmetric(vertical: 15, horizontal: 20),
      padding: REdgeInsets.symmetric(vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: listBottomNav,
      ),
    );
  }
}

class IconTab extends StatelessWidget {
  const IconTab({
    super.key,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });
  final Function()? onTap;
  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1 : .25,
        child: SvgPicture.asset(
          icon,
          width: 28.w,
          height: 28.h,
        ),
      ),
    );
  }
}
