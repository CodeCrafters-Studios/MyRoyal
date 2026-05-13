import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:flutter/services.dart';

class CustomButtomBar extends StatelessWidget {
  const CustomButtomBar({
    super.key,
    required this.listBottomNav,
  });

  final List<Widget> listBottomNav;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.fromLTRB(20, 0, 20, 20),
      child: CardApp(
        radius: 28,
        isShadow: true,
        shadows: Shadows.floating,
        padding: REdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: listBottomNav,
        ),
      ),
    );
  }
}

class IconTab extends StatelessWidget {
  const IconTab({
    super.key,
    this.name,
    required this.icon,
    required this.isSelected,
    this.onTap,
  });
  final Function()? onTap;
  final String? name;
  final String icon;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.selectionClick();
        }
        if (onTap != null) onTap!();
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.0 : 0.85,
              duration: const Duration(milliseconds: 200),
              child: SvgPicture.asset(
                icon,
                width: 29.w,
                height: 29.h,
                colorFilter: isSelected
                    ? ColorFilter.mode(primary, BlendMode.srcIn)
                    : const ColorFilter.mode(
                        Color(0xFFBDBDBD), BlendMode.srcIn),
              ),
            ),
            if (isSelected && name != null) ...[
              4.verticalSpace,
              Text(
                name!,
                style: TS.caption.copyWith(
                  color: primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
