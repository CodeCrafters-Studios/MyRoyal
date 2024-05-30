import 'package:flutter/material.dart';
import 'package:iroyal/base/design/styles.dart';

class LogButton extends StatelessWidget {
  const LogButton({super.key, required this.color, required this.onTap});
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: IconSizes.xl,
      width: IconSizes.xl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: IconSizes.xl,
          height: IconSizes.xl,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: Corners.xxlBorder,
            color: color,
          ),
          child: const Icon(Icons.bug_report),
        ),
      ),
    );
  }
}
