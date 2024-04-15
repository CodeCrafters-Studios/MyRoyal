import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/app_pop_scope.dart';
import 'package:iroyal/base/widgets/appbar_default.dart';

class PageBase extends StatelessWidget {
  const PageBase({
    super.key,
    required this.child,
    this.appBar,
    this.resizeInsetsBottom = true,
    this.onBack,
    this.showIconBack = true,
    this.title = 'Appbar Title',
    this.centeredTitle = false,
    this.actions,
    this.bottomBar,
    this.bottomBarHeight,
    this.isShowLogoAppbar = true,
    this.drawer,
    this.useTopPadding = false,
    this.appbarColor,
    this.bgColors,
    this.showBackground = true,
    this.bottomBarDecoration,
    this.showBackgroundLogin = false,
  });
  final Widget child;
  final Widget? appBar;
  final bool resizeInsetsBottom;

  final Function()? onBack;
  final bool showIconBack;
  final String title;
  final bool centeredTitle;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final double? bottomBarHeight;
  final bool isShowLogoAppbar;
  final Widget? drawer;
  final bool useTopPadding;
  final Color? appbarColor;
  final Color? bgColors;
  final bool showBackground;
  final bool showBackgroundLogin;
  final BoxDecoration? bottomBarDecoration;

  @override
  Widget build(BuildContext context) {
    return AppPopScope(
      onBack: () {
        onBack != null ? onBack!() : Get.back();
      },
      child: Scaffold(
        key: key,
        backgroundColor: bgColors ?? (Get.isDarkMode ? bgColorDark : bgColor),
        resizeToAvoidBottomInset: resizeInsetsBottom,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (showBackground)
              showBackgroundLogin == false
                  ? Image.asset(
                      'assets/images/img_motif.png',
                      width: Get.width,
                      height: Get.height,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/img_bg_login.png',
                      width: Get.width,
                      height: Get.height,
                      fit: BoxFit.cover,
                    ),
            SizedBox(height: Get.height, width: Get.width),
            if (useTopPadding)
              Padding(
                padding: EdgeInsets.only(
                  top: AppConfig.iAppBarHeight +
                      MediaQuery.of(context).viewPadding.top,
                ),
                child: child,
              )
            else
              child,
            appBar ??
                AppbarDefault(
                  onBack: onBack,
                  showIconBack: showIconBack,
                  title: title,
                  centeredTitle: centeredTitle,
                  actions: actions,
                  color: appbarColor,
                ),
            if (bottomBar != null)
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  decoration: bottomBarDecoration ??
                      BoxDecoration(
                        color: Get.isDarkMode ? bgColorDark : bgColor,
                      ),
                  height: bottomBarHeight,
                  child: bottomBar,
                ),
              ),
            if (drawer != null) drawer!,
          ],
        ),
      ),
    );
  }
}
