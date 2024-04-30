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
      width: 375,
      height: 70,
      radius: 0,
      isShadow: true,
      shadows: Shadows.up,
      padding: REdgeInsets.symmetric(vertical: 12, horizontal: 34),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconTab(
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
          IconTab(
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
          mainAxisSize: MainAxisSize.min,
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
