import 'package:flutter/material.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/loading_indicator.dart';

class ButtonPrimaryOutlined extends StatelessWidget {
  const ButtonPrimaryOutlined({
    super.key,
    required this.onPressed,
    this.child,
    this.loadingColor = Colors.white,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero,
    this.fullWidth = false,
    this.elevation = 0,
    this.isLoading = false,
    this.loadingWidget,
    this.textColor,
    this.icon,
    this.suffixIcon,
    this.onLongPressed,
    this.alignment,
    this.borderSide,
    this.text = 'Button',
    this.enable = true,
    this.borderRadius = 10,
    this.isOutline = true,
    this.outlineColor = primaryColor,
    this.textStyle,
    this.color,
  });

  ///receive a ValueNotifier to indicate a loading widget
  final bool isLoading;
  final bool enable;

  ///
  final Widget? child;
  final String text;
  final TextStyle? textStyle;

  ///An icon to show at before [child]
  final Widget? icon;
  final Widget? suffixIcon;

  ///
  final VoidCallback? onPressed;

  ///
  final Function? onLongPressed;

  //
  final double? elevation;

  ///Button's background Color

  ///Text's color for a child that usually a Text
  final Color? textColor;

  ///Loading indicator's color, default is white
  final Color loadingColor;

  ///A widget to show when loading, if the value is null,
  ///it will use a loading widget from SuraProvider or CircularProgressIndicator
  final Widget? loadingWidget;

  ///Button's margin
  final EdgeInsets margin;

  ///Button's padding
  final EdgeInsets padding;

  ///child's alignment
  final MainAxisAlignment? alignment;

  ///if [fullWidth] is `true`, Button will take all remaining horizontal space
  final bool fullWidth;

  ///
  final BorderSide? borderSide;
  final double borderRadius;
  final bool isOutline;
  final Color outlineColor;
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 100),
      width: fullWidth ? double.infinity : null,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        color: color ?? Colors.transparent,
      ),
      margin: margin,
      child: ElevatedButton(
        onPressed: isLoading
            ? () {}
            : enable
                ? onPressed
                : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: textColor,
          backgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
            side: BorderSide(color: outlineColor),
          ),
          padding: padding,
          elevation: 0,
          side: borderSide,
        ),
        child: Visibility(
          visible: isLoading,
          replacement: Row(
            mainAxisAlignment: alignment ?? MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (icon != null) ...[
                icon ?? emptyBox,
              ],
              Padding(
                padding: const EdgeInsets.all(12),
                child: child ??
                    Text(
                      text,
                      style: textStyle ??
                          TS.titleSmall
                              .copyWith(color: textColor ?? primaryColor),
                    ),
              ),
              if (suffixIcon != null) ...[
                suffixIcon ?? emptyBox,
              ],
            ],
          ),
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: LoadingIndicator(),
          ),
        ),
      ),
    );
  }
}
