import 'package:flutter/material.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';

class CardApp extends StatelessWidget {
  const CardApp({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.borderWidth = 0,
    this.color = Colors.white,
    this.outlineColor = borderSubtle,
    this.isOutlined = false,
    this.margin,
    this.padding,
    this.child,
    this.shadows,
    this.isShadow = true,
    this.onTap,
    this.gradient,
  });
  final double? width;
  final double? height;
  final double? radius;
  final double borderWidth;
  final Color color;
  final Color outlineColor;
  final bool isOutlined;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Widget? child;
  final List<BoxShadow>? shadows;
  final bool isShadow;
  final Function()? onTap;

  /// Optional gradient — takes priority over [color] when set
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    final effectiveRadius = radius ?? 14.0;
    final borderRadius =
        BorderRadius.all(Radius.circular(effectiveRadius));

    final defaultShadow = [
      BoxShadow(
        color: primary.withOpacity(0.06),
        blurRadius: 12,
        offset: const Offset(0, 3),
      ),
      BoxShadow(
        color: primary.withOpacity(0.03),
        blurRadius: 24,
        offset: const Offset(0, 8),
      ),
    ];

    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      decoration: isOutlined
          ? BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: outlineColor, width: borderWidth),
              color: gradient == null ? color : null,
              gradient: gradient,
              boxShadow: isShadow ? (shadows ?? defaultShadow) : [],
            )
          : BoxDecoration(
              borderRadius: borderRadius,
              color: gradient == null ? color : null,
              gradient: gradient,
              boxShadow: isShadow ? (shadows ?? defaultShadow) : [],
            ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: InkWellTap(
          onTap: onTap,
          child: child ?? emptyBox,
        ),
      ),
    );
  }
}
