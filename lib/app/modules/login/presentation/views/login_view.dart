import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_images/logo.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
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
                  InputPrimary(
                    key: const Key('inputUsername'),
                    label: 'Username',
                    hint: 'Username',
                    onChanged: (value) => controller.setLoginValue(
                      FormLoginValue.username,
                      value,
                    ),
                    validation: (value) =>
                        value?.isEmpty ?? false ? 'Cannot be empty' : null,
                    prefixIcon: const EPadding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ImageIcon(
                        AssetImage('assets/icons/ic_user.png'),
                        size: 20,
                        color: greyIcon,
                      ),
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
                    validation: (value) =>
                        value?.isEmpty ?? false ? 'Cannot be empty' : null,
                    prefixIcon: const EPadding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ImageIcon(
                        AssetImage('assets/icons/ic_lock.png'),
                        size: 20,
                        color: greyIcon,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        key: const Key('loginForgotPassword'),
                        onPressed: () {
                          // Get.toNamed(Routes.ONBOARDING_REGISTER);
                        },
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(
                            color: primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Obx(
              () => ButtonPrimary(
                margin: const EdgeInsets.symmetric(horizontal: 16),
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
          ],
        ),
      ),
    );
  }
}

class OrLoginWith extends StatelessWidget {
  const OrLoginWith({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: grey,
          ),
        ),
        20.horizontalSpace,
        const Text(
          'Or login with',
          style: TextStyle(fontSize: 14),
        ),
        20.horizontalSpace,
        Expanded(
          child: Container(
            height: 1,
            color: grey,
          ),
        ),
      ],
    );
  }
}

class BiometricsLogin extends StatelessWidget {
  const BiometricsLogin({super.key, required this.onTap});

  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWellTap(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/icons/ic_fingerprint.png',
            width: 42,
            height: 42,
          ),
          Container(
            height: 56,
            width: 1,
            color: Colors.black,
            margin: REdgeInsets.symmetric(horizontal: 16),
          ),
          Image.asset(
            'assets/icons/ic_face_id.png',
            width: 42,
            height: 42,
          ),
        ],
      ),
    );
  }
}
