import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/config/app_config.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/app_pop_scope.dart';
import 'package:MyRoyal/base/widgets/appbar_default.dart';

class PageBase extends StatelessWidget {
  const PageBase({
    super.key,
    required this.child,
    this.appBar,
    this.resizeInsetsBottom = true,
    this.onBack,
    this.showIconBack = true,
    this.title = 'Appbar Title',
    this.actions,
    this.centeredTitle = false,
    this.textStyle,
    this.bottomBar,
    this.bottomBarHeight,
    this.isShowLogoAppbar = true,
    this.drawer,
    this.useTopPadding = false,
    this.appbarColor = primary,
    this.bgColors,
    this.iconColor,
    this.showBackground = true,
    this.bottomBarDecoration,
    this.showBackgroundLogin = false,
    this.floatingActionButton,
  });
  final Widget child;
  final Widget? appBar;
  final bool resizeInsetsBottom;

  final Function()? onBack;
  final bool showIconBack;
  final String title;
  final TextStyle? textStyle;
  final bool centeredTitle;
  final List<Widget>? actions;
  final Widget? bottomBar;
  final double? bottomBarHeight;
  final bool isShowLogoAppbar;
  final Widget? drawer;
  final bool useTopPadding;
  final Color? appbarColor;
  final Color? bgColors;
  final Color? iconColor;
  final bool showBackground;
  final bool showBackgroundLogin;
  final BoxDecoration? bottomBarDecoration;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return AppPopScope(
      onBack: () {
        onBack != null ? onBack!() : Get.back();
      },
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        key: key,
        backgroundColor: bgColors ?? (Get.isDarkMode ? bgColorDark : bgColor),
        resizeToAvoidBottomInset: resizeInsetsBottom,
        body: Stack(
          alignment: Alignment.topCenter,
          children: [
            if (showBackground)
              Positioned.fill(
                child: showBackgroundLogin == false
                    ? Opacity(
                        opacity: 0.18,
                        child: Image.asset(
                          'assets/images/img_motif.png',
                          width: Get.width,
                          height: Get.height,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Image.asset(
                        'assets/images/img_bg_login.png',
                        width: Get.width,
                        height: Get.height,
                        fit: BoxFit.cover,
                      ),
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
                  iconColor: iconColor,
                  textStyle: textStyle,
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
