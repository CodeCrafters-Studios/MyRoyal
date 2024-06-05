import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/login/presentation/views/components/biometric_login.dart';
import 'package:iroyal/app/modules/login/presentation/views/components/have_no_account.dart';
import 'package:iroyal/app/modules/login/presentation/views/components/or_login_with.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_images/logo.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/padding.dart';
import 'package:iroyal/base/widgets/page_base.dart';
import 'package:iroyal/base/widgets/textfield/input_password.dart';
import 'package:iroyal/base/widgets/textfield/input_primary.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackgroundLogin: true,
      appBar: const SizedBox.shrink(),
      resizeInsetsBottom: false,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            85.verticalSpace,
            const Logo(),
            35.verticalSpace,
            CardApp(
              isShadow: true,
              shadows: Shadows.small,
              padding: REdgeInsets.all(8),
              margin: REdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Obx(
                    () => InputPrimary(
                      focusNode: controller.focusNodeUsername,
                      controller: controller.usernameController,
                      key: const Key('inputUsername'),
                      label: 'Username',
                      hint: 'Username',
                      onChanged: (value) => controller.setLoginValue(
                        FormLoginValue.username,
                        value,
                      ),
                      validation: (value) =>
                          value?.isEmpty ?? false ? 'Cannot be empty' : null,
                      prefixIcon: EPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: ImageIcon(
                          const AssetImage('assets/icons/ic_user.png'),
                          size: 20.dm,
                          color: greyIcon,
                        ),
                      ),
                      suffixIcon: controller.isFocus.value
                          ? IconButton(
                              onPressed: controller.clear,
                              icon: const Icon(Icons.clear),
                            )
                          : null,
                    ),
                  ),
                  10.verticalSpace,
                  InputPassword(
                    key: const Key('inputPassword'),
                    hint: 'Password',
                    onChanged: (value) => controller.setLoginValue(
                      FormLoginValue.password,
                      value,
                    ),
                    validation: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password cannot be empty';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                    prefixIcon: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ImageIcon(
                        const AssetImage('assets/icons/ic_lock.png'),
                        size: 20.dm,
                        color: greyIcon,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        key: const Key('loginForgotPassword'),
                        onPressed: controller.gotoForgotPassword,
                        child: Text('Forgot Password?',
                            style: TS.bodyMedium.copyWith(color: primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Obx(
              () => ButtonPrimary(
                margin: REdgeInsets.symmetric(horizontal: 16),
                key: const Key('loginBtn'),
                onPressed: controller.getParams,
                isLoading: controller.isLoading.value,
                text: 'Login',
                fullWidth: true,
              ),
            ),
            30.verticalSpace,
            const EPadding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: OrLoginWith(),
            ),
            30.verticalSpace,
            BiometricsLogin(
              key: const Key('loginBiometrics'),
              onTap: controller.biometricAuthentication,
            ),
            20.verticalSpace,
            HaveNoAccount(
              key: const Key('loginNoAccount'),
              onTap: controller.dontHaveAnAccount,
            ),
          ],
        ),
      ),
    );
  }
}
