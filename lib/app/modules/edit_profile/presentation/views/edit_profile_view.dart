import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      resizeInsetsBottom: false,
      showBackground: false,
      title: 'Edit Profile',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            Text(
              'Edit your profile data',
              style: TS.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            10.verticalSpace,
            Text(
              'Customize your profile data. Ensure it match with your data right now.',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
            ),
            30.verticalSpace,
            InputPrimary(
              controller: controller.emailController,
              label: 'Personal Email',
              color: white,
              outlineColor: grey,
              hint: 'Enter your personal email',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) => controller.setEditProfileValue(
                FormLoginValue.email,
                value,
              ),
            ),
            20.verticalSpace,
            InputPrimary(
              label: 'NPWP',
              color: white,
              outlineColor: grey,
              hint: 'Enter your NPWP',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) => controller.setEditProfileValue(
                FormLoginValue.npwp,
                value,
              ),
            ),
            const Spacer(),
            ButtonPrimary(
              fullWidth: true,
              margin: REdgeInsets.only(left: 16, bottom: 20, right: 16),
              text: 'Continue',
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}
