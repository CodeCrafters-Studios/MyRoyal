import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({super.key, this.color, this.thickness});
  final Color? color;
  final double? thickness;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? greySecond,
      thickness: thickness ?? 1,
    );
  }
}
