import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/base/config/app_config.dart';
import 'package:MyRoyal/base/design/colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    platform: TargetPlatform.iOS,
    primaryColor: MaterialColor(primary.value, materialColor),
    primarySwatch: MaterialColor(primaryColor.value, materialColor),
    fontFamily: AppConfig.fontFamily,
    splashColor: Colors.white24,
    splashFactory: InkRipple.splashFactory,
    scaffoldBackgroundColor: bgColor,
    textTheme: context.textTheme.apply(bodyColor: appTextColor),
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: secondary,
      primary: primary,
      surface: cardColor,
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(14.r)),
      ),
      margin: EdgeInsets.zero,
    ),
    dividerTheme: const DividerThemeData(
      color: borderSubtle,
      thickness: 1,
      space: 1,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.r)),
      ),
      titleTextStyle: TS.titleMedium.copyWith(color: primary),
      contentTextStyle: TS.bodySmall.copyWith(color: appTextColor),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: inputColor,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: const BorderSide(color: borderSubtle),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: const BorderSide(color: borderSubtle),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: const BorderSide(color: secondary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: const BorderSide(color: errorColor),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12.r)),
        borderSide: const BorderSide(color: errorColor, width: 1.5),
      ),
      hintStyle: TS.bodyMedium.copyWith(color: appHintColor),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12.r)),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        textStyle: TS.labelLarge.copyWith(color: white),
      ),
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: primary,
      foregroundColor: white,
      titleTextStyle: TS.titleSmall.copyWith(color: white),
      iconTheme: const IconThemeData(color: white),
      scrolledUnderElevation: 0,
    ),
    tabBarTheme: TabBarThemeData(
      labelColor: primary,
      unselectedLabelColor: greyText,
      indicator: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8.r)),
        color: primary.withOpacity(0.08),
      ),
      indicatorSize: TabBarIndicatorSize.tab,
      labelStyle: TS.labelMedium.copyWith(fontWeight: FontWeight.w700),
      unselectedLabelStyle: TS.labelMedium,
    ),
  );
}

ThemeData darkTheme(BuildContext context) {
  return ThemeData(
    platform: TargetPlatform.iOS,
    primaryColor: MaterialColor(primaryDark.value, materialColor),
    primarySwatch: MaterialColor(primaryDark.value, materialColor),
    fontFamily: AppConfig.fontFamily,
    splashColor: Colors.white24,
    scaffoldBackgroundColor: bgColorDark,
    textTheme: context.textTheme.apply(bodyColor: Colors.white),
    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: secondary),
  );
}

class Insets {
  static double get xs => 4.w;
  static double get sm => 8.w;
  static double get med => 12.w;
  static double get lg => 16.w;
  static double get xl => 20.w;
  static double get xxl => 32.w;
}

class IconSizes {
  static double get xs => 12.w;
  static double get sm => 20.w;
  static double get med => 28.w;
  static double get lg => 32.w;
  static double get xl => 48.w;
  static double get xxl => 64.w;
}

class Paddings {
  static EdgeInsets get xxs => REdgeInsets.all(2);
  static EdgeInsets get xs => REdgeInsets.all(4);
  static EdgeInsets get sm => REdgeInsets.all(8);
  static EdgeInsets get med => REdgeInsets.all(12);
  static EdgeInsets get lg => REdgeInsets.all(16);
  static EdgeInsets get xl => REdgeInsets.all(20);
  static EdgeInsets get xxl => REdgeInsets.all(32);

  static EdgeInsets hv(double h, double v) =>
      REdgeInsets.symmetric(horizontal: h, vertical: v);
}

class Corners {
  static double get xs => 4.r;
  static double get sm => 8.r;
  static double get lsm => 10.r;
  static double get med => 12.r;
  static double get slg => 14.r;
  static double get lg => 16.r;
  static double get xl => 20.r;
  static double get xll => 24.r;
  static double get xxl => 32.r;

  static Radius get xsRadius => Radius.circular(xs);
  static Radius get smRadius => Radius.circular(sm);
  static Radius get medRadius => Radius.circular(med);
  static Radius get lgRadius => Radius.circular(lg);
  static Radius get xlRadius => Radius.circular(xl);
  static Radius get xxlRadius => Radius.circular(xxl);

  static BorderRadius get xsBorder => BorderRadius.all(xsRadius);
  static BorderRadius get smBorder => BorderRadius.all(smRadius);
  static BorderRadius get medBorder => BorderRadius.all(medRadius);
  static BorderRadius get lgBorder => BorderRadius.all(lgRadius);
  static BorderRadius get xlBorder => BorderRadius.all(xlRadius);
  static BorderRadius get xxlBorder => BorderRadius.all(xxlRadius);
}

// Default Material Text Styles
class TS {
  static TextStyle ts = TextStyle(
    fontFamily: AppConfig.fontFamily,
    letterSpacing: 0,
    fontWeight: FontWeight.w400,
    color: appTextColor,
  );

  static TextStyle get displayLarge => ts.copyWith(fontSize: 57.sp);
  static TextStyle get displayMedium => ts.copyWith(fontSize: 45.sp);
  static TextStyle get displaySmall => ts.copyWith(fontSize: 44.sp);

  static TextStyle get headlineLarge => ts.copyWith(
        fontSize: 32.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      );
  static TextStyle get headlineMedium => ts.copyWith(
        fontSize: 28.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.3,
      );
  static TextStyle get headlineSmall => ts.copyWith(
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.2,
      );

  static TextStyle get titleLarge =>
      ts.copyWith(fontSize: 20.sp, fontWeight: FontWeight.w700, letterSpacing: -0.2);
  static TextStyle get titleMedium => ts.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );
  static TextStyle get titleSmall => ts.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
      );

  static TextStyle get labelLarge => ts.copyWith(
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );
  static TextStyle get labelMedium => ts.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
      );
  static TextStyle get labelSmall => ts.copyWith(
        fontSize: 11.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.2,
      );

  static TextStyle get bodyLarge => ts.copyWith(
        fontSize: 16.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyMedium => ts.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyMediumBold => ts.copyWith(
        fontSize: 14.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.bold,
      );
  static TextStyle get bodySmall => ts.copyWith(
        fontSize: 12.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.w500,
      );
  static TextStyle get bodyMini => ts.copyWith(
        fontSize: 10.sp,
        letterSpacing: 0,
      );

  static TextStyle get caption => ts.copyWith(
        fontSize: 10.sp,
        letterSpacing: 0,
        fontWeight: FontWeight.w600,
      );
}

class Shadows {
  static List<BoxShadow> get universal => [
        BoxShadow(
          color: primary.withOpacity(0.06),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: primary.withOpacity(0.04),
          blurRadius: 32,
          offset: const Offset(0, 10),
        ),
      ];

  static List<BoxShadow> get up => [
        BoxShadow(
          offset: const Offset(0, -4),
          blurRadius: 16,
          spreadRadius: 0,
          color: primary.withOpacity(0.08),
        ),
      ];

  static List<BoxShadow> get small => [
        BoxShadow(
          color: primary.withOpacity(0.07),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
        BoxShadow(
          color: primary.withOpacity(0.04),
          blurRadius: 20,
          offset: const Offset(0, 6),
        ),
      ];

  /// Stronger shadow for floating elements (bottom nav, modals)
  static List<BoxShadow> get floating => [
        BoxShadow(
          color: primary.withOpacity(0.10),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: primary.withOpacity(0.06),
          blurRadius: 48,
          offset: const Offset(0, 16),
        ),
      ];
}
