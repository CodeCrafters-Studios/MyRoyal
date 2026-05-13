import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/others/success_change_security_view.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_password.dart';

import '../controllers/change_pin_controller.dart';

class ChangePinView extends GetView<ChangePinController> {
  const ChangePinView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      resizeInsetsBottom: false,
      showBackground: false,
      title: 'Change PIN',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AppbarSpacer(),
            Text(
              'Set a new PIN',
              style: TS.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            10.verticalSpace,
            Text(
              'Create a new PIN. Ensure it differs from previous ones for security',
              style: TS.bodyMedium.copyWith(fontWeight: FontWeight.w400),
            ),
            30.verticalSpace,
            InputPassword(
              label: 'Current PIN',
              key: const Key('currentPIN'),
              maxLength: 6,
              keyboardType: TextInputType.number,
              color: white,
              outlineColor: grey,
              hint: 'Enter your current PIN',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) {},
            ),
            20.verticalSpace,
            InputPassword(
              label: 'New PIN',
              key: const Key('newPIN'),
              maxLength: 6,
              keyboardType: TextInputType.number,
              color: white,
              outlineColor: grey,
              hint: 'Enter your new PIN',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) => controller.setNewPin(value),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'PIN cannot be empty';
                } else if (value.length < 6) {
                  return 'PIN must be at least 6 characters long';
                }
                return null;
              },
            ),
            20.verticalSpace,
            InputPassword(
              label: 'Confirm PIN',
              key: const Key('confirmPIN'),
              maxLength: 6,
              keyboardType: TextInputType.number,
              color: white,
              outlineColor: grey,
              hint: 'Re-enter PIN',
              hintStyle: TS.bodyMedium.copyWith(
                color: grey,
              ),
              onChanged: (value) => controller.setConfirmPin(value),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  return 'PIN cannot be empty';
                } else if (value.length < 6) {
                  return 'PIN must be at least 6 characters long';
                } else if (value != controller.newPin.value) {
                  return 'PIN do not match. Try again.';
                }
                return null;
              },
            ),
            const Spacer(),
            ButtonPrimary(
              fullWidth: true,
              margin: REdgeInsets.only(left: 16, bottom: 20, right: 16),
              text: 'Lanjut',
              onPressed: () => Get.offAll(
                () => const SuccessChangeSecurityView(
                  subtitle: 'PIN',
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
