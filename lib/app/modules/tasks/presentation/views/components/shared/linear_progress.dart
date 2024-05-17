import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';

class LinearProgress extends StatelessWidget {
  const LinearProgress({
    super.key,
    required this.percentageText,
    required this.valueLinear,
    required this.percentageColor,
    required this.progressColor,
  });

  final String percentageText;
  final double valueLinear;
  final Color percentageColor;
  final Color? progressColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Progress',
              style: TS.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '$percentageText complete',
              style: TS.bodyMedium.copyWith(color: progressColor),
            ),
          ],
        ),
        15.verticalSpace,
        LinearProgressIndicator(
          color: percentageColor,
          backgroundColor: greyHint,
          value: valueLinear,
        ),
      ],
    );
  }
}
