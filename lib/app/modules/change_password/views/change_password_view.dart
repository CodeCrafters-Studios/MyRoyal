import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/change_password/views/components/success_change_password_view.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_password.dart';

import '../controllers/change_password_controller.dart';

class ChangePasswordView extends GetView<ChangePasswordController> {
  const ChangePasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangePasswordViewImpl(
      controller: controller,
    );
  }
}

class ChangePasswordViewImpl extends StatelessWidget {
  const ChangePasswordViewImpl({
    super.key,
    required this.controller,
  });

  final ChangePasswordController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      resizeInsetsBottom: false,
      showBackground: false,
      title: 'Change Password',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            Text(
              'Set a new password',
              style: TS.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            10.verticalSpace,
            Text(
              'Create a new password. Ensure it differs from previous ones for security',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
            ),
            30.verticalSpace,
            InputPassword(
              label: 'Current Password',
              key: const Key('currentPassword'),
              color: white,
              outlineColor: grey,
              hint: 'Enter your current password',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) {},
              // validation: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Password cannot be empty';
              //   } else if (value.length < 6) {
              //     return 'Password must be at least 6 characters long';
              //   }
              //   return null;
              // },
            ),
            20.verticalSpace,
            InputPassword(
              label: 'New Password',
              key: const Key('newPassword'),
              color: white,
              outlineColor: grey,
              hint: 'Enter your new password',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) {},
              // validation: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Password cannot be empty';
              //   } else if (value.length < 6) {
              //     return 'Password must be at least 6 characters long';
              //   }
              //   return null;
              // },
            ),
            20.verticalSpace,
            InputPassword(
              label: 'Confirm Password',
              key: const Key('confirmPassword'),
              color: white,
              outlineColor: grey,
              hint: 'Re-enter password',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) {},
              // validation: (value) {
              //   if (value == null || value.isEmpty) {
              //     return 'Password cannot be empty';
              //   } else if (value.length < 6) {
              //     return 'Password must be at least 6 characters long';
              //   }
              //   return null;
              // },
            ),
            const Spacer(),
            ButtonPrimary(
              fullWidth: true,
              margin: REdgeInsets.only(bottom: 20),
              text: 'Continue',
              onPressed: () => Get.offAll(
                () => const SuccessChangePasswordView(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
