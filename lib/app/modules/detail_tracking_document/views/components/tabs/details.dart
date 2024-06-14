import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/padding.dart';

class DetailsDocumentView extends StatelessWidget {
  const DetailsDocumentView({super.key});

  @override
  Widget build(BuildContext context) {
    return EPadding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          Text(
            'Descriptions:',
            style: TS.bodyLarge,
          ),
          20.verticalSpace,
          Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
            style: TS.bodyMedium,
          )
        ],
      ),
    );
  }
}
