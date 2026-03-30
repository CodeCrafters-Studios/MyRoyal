import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';
import 'package:MyRoyal/app/modules/profile/presentation/controllers/profile_controller.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/app_divider.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({
    super.key,
    required this.label,
    required this.value,
    required this.controller,
  });

  final String label;
  final String value;
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TS.bodySmall.copyWith(fontWeight: FontWeight.w300),
        ),
        5.verticalSpace,
        controller.isLoading.value
            ? ShimmerText(
                height: 15.h,
                width: 150.w,
              )
            : Text(
                value,
                style: TS.bodyMedium,
              ),
        const AppDivider(),
        15.verticalSpace,
      ],
    );
  }
}
