import 'package:flutter/material.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:readmore/readmore.dart';

class DescriptionDetailTask extends StatelessWidget {
  const DescriptionDetailTask({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: ReadMoreText(
        description,
        style: TS.bodyMedium.copyWith(color: greyText),
        trimMode: TrimMode.Line,
        trimLines: 2,
        colorClickableText: primary,
        trimCollapsedText: ' Show more',
        trimExpandedText: '  Show less',
        moreStyle:
            TS.bodyMedium.copyWith(color: primary, fontWeight: FontWeight.w600),
        lessStyle:
            TS.bodyMedium.copyWith(color: primary, fontWeight: FontWeight.w600),
      ),
    );
  }
}
