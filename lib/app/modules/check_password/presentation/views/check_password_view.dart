import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_password.dart';

import '../controllers/check_password_controller.dart';

class CheckPasswordView extends GetView<CheckPasswordController> {
  const CheckPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      useTopPadding: true,
      title: 'Check Password',
      child: EPadding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InputPassword(
              hint: 'Enter your password AD',
              onChanged: (value) => controller.setLoginValue(value),
              validation: (value) {
                if (value == null || value.isEmpty) {
                  controller.isValidForm(false);
                  return 'Password cannot be empty';
                }
                return null;
              },
              prefixIcon: EPadding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ImageIcon(
                  const AssetImage('assets/icons/ic_lock.png'),
                  size: 20.r,
                  color: greyIcon,
                ),
              ),
            ),
            16.verticalSpace,
            TextButton(
              onPressed: () => controller.gotoForgotPassword(),
              child: Text(
                'Forgot Password?',
                style: TS.bodySmall
                    .copyWith(fontWeight: FontWeight.bold, color: secondary),
              ),
            ),
            16.verticalSpace,
            Obx(
              () => ButtonPrimary(
                fullWidth: true,
                margin: REdgeInsets.symmetric(horizontal: 100),
                enable: controller.isValidForm.value,
                isLoading: controller.isLoading.value,
                onPressed: () => controller.checkPassword(),
                text: 'Submit',
              ),
            )
          ],
        ),
      ),
    );
  }
}
