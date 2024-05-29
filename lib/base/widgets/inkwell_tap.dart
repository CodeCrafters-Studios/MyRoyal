import 'package:flutter/material.dart';

class InkWellTap extends StatelessWidget {
  const InkWellTap({
    super.key,
    this.onTap,
    required this.child,
    this.radius,
    this.color,
  });
  final Function()? onTap;
  final Widget child;
  final double? radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? Colors.transparent,
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius ?? 0),
      ),
      child: InkWell(onTap: onTap, child: child),
    );
  }
}
