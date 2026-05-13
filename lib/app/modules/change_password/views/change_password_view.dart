import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/others/success_change_security_view.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_password.dart';

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
              onChanged: (value) => controller.setNewPassword(value),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                }
                return null;
              },
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
              onChanged: (value) => controller.setConfirmPassword(value),
              validation: (value) {
                AppUtils.logApp('HERE ${controller.newPassword.value}');
                if (value == null || value.isEmpty) {
                  return 'Password cannot be empty';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                } else if (value != controller.newPassword.value) {
                  return 'Password do not match. Try again.';
                }
                return null;
              },
            ),
            5.verticalSpace,
            SizedBox(
              width: Get.width,
              child: Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    minVerticalPadding: 0,
                    horizontalTitleGap: 10,
                    leading: Icon(
                      Icons.check_circle,
                      color: grey,
                      size: 20.r,
                    ),
                    title: Text(
                      'Password must contains atleast 1 special characters',
                      style: TS.bodySmall,
                    ),
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 10,
                    leading: Obx(
                      () => Icon(
                        Icons.check_circle,
                        color: controller.containsNumber.value ? green : grey,
                        size: 20.r,
                      ),
                    ),
                    title: Text(
                      'Password must contains Numbers',
                      style: TS.bodySmall,
                    ),
                  ),
                  ListTile(
                    visualDensity:
                        const VisualDensity(horizontal: 0, vertical: -4),
                    minVerticalPadding: 0,
                    contentPadding: EdgeInsets.zero,
                    minLeadingWidth: 0,
                    horizontalTitleGap: 10,
                    leading: Icon(
                      Icons.check_circle,
                      color: grey,
                      size: 20.r,
                    ),
                    title: Text(
                      'Password must contains capital letter',
                      style: TS.bodySmall,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ButtonPrimary(
              fullWidth: true,
              margin: REdgeInsets.only(left: 16, bottom: 20, right: 16),
              text: 'Lanjut',
              onPressed: () => Get.offAll(
                () => const SuccessChangeSecurityView(
                  subtitle: 'password',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
