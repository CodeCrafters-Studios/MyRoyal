import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';

class CustomBottomNavBar extends StatefulWidget {
  const CustomBottomNavBar(
      {super.key, required this.index, this.initialIndex = 0});

  final ValueChanged<int> index;
  final int initialIndex;

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int index = 0;

  @override
  void initState() {
    index = widget.initialIndex;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CardApp(
      width: 380.w,
      height: 75.h,
      radius: 0,
      isShadow: true,
      shadows: Shadows.up,
      padding: REdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: IconTab(
              icon: 'assets/icons/ic_tab_home.svg',
              name: 'Home',
              isSelected: index == 0,
              onTap: () {
                setState(() {
                  index = 0;
                });
                widget.index.call(index);
              },
            ),
          ),
          Expanded(
            child: IconTab(
              icon: 'assets/icons/ic_settings.svg',
              name: 'Settings',
              isSelected: index == 1,
              onTap: () {
                setState(() {
                  index = 1;
                });
                widget.index.call(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class IconTab extends StatelessWidget {
  const IconTab({
    super.key,
    required this.icon,
    required this.name,
    required this.isSelected,
    this.onTap,
  });
  final Function()? onTap;
  final String icon;
  final String name;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: isSelected ? 1 : .25,
        child: Column(
          children: [
            SvgPicture.asset(
              icon,
              width: 28.w,
              height: 28.h,
            ),
            5.verticalSpace,
            Text(
              name,
              style: TS.caption.copyWith(color: primary),
            ),
          ],
        ),
      ),
    );
  }
}
