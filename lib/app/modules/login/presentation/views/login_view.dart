import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/app_images/logo.dart';
import 'package:iroyal/base/widgets/buttons/button_primary.dart';
import 'package:iroyal/base/widgets/card_app.dart';
import 'package:iroyal/base/widgets/inkwell_tap.dart';
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
      appBar: emptyBox,
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
              margin: const EdgeInsets.all(16),
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
                    validation: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                    prefixIcon: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 12),
                      child: Image.asset(
                        'assets/icons/ic_user.png',
                        width: 20.w,
                        height: 20.w,
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
                    prefixIcon: Padding(
                      padding: REdgeInsets.symmetric(horizontal: 12),
                      child: Image.asset(
                        'assets/icons/ic_lock.png',
                        width: 20.w,
                        height: 20.w,
                      ),
                    ),
                    validation: (value) {
                      if (value != null && value.isEmpty) {
                        return 'Cannot be empty';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        key: const Key('loginForgotPassword'),
                        onPressed: () {
                          // Get.toNamed(Routes.ONBOARDING_REGISTER);
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TS.caption.copyWith(
                            color: primary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Obx(
                    () => ButtonPrimary(
                      key: const Key('loginBtn'),
                      onPressed: controller.getParams,
                      isLoading: controller.isLoading.value,
                      text: 'login',
                      fullWidth: true,
                    ),
                  ),
                  10.verticalSpace
                ],
              ),
            ),
            30.verticalSpace,
            Padding(
              padding: REdgeInsets.symmetric(horizontal: 16),
              child: const OrLoginWith(),
            ),
            50.verticalSpace,
            BiometricsLogin(
              key: const Key('loginBiometrics'),
              onTap: controller.biometricAuthentication,
            ),

            // const HaveNoAccount(
            //   key: Key('loginNoAccount'),
            // ),
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Or login with',
            style: TS.bodySmall,
          ),
        ),
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
  const BiometricsLogin({super.key, this.onTap});
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
            width: 42.w,
            height: 42.w,
          ),
          Container(
            height: 56.w,
            width: 1,
            color: Colors.black,
            margin: REdgeInsets.symmetric(horizontal: 16),
          ),
          Image.asset(
            'assets/icons/ic_face_id.png',
            width: 42.w,
            height: 42.w,
          ),
        ],
      ),
    );
  }
}

// class HaveNoAccount extends StatelessWidget {
//   const HaveNoAccount({super.key, this.onTap});
//   final Function()? onTap;

//   @override
//   Widget build(BuildContext context) {
//     final stringArray = 'Belum Punya Akun? ^Klik^ disini'.split('^');
//     return RichText(
//       text: TextSpan(
//         children: stringArray.mapIndexed((index, element) {
//           if (index.isEven) {
//             return TextSpan(
//               text: element,
//               style: TS.bodySmall.copyWith(color: appTextColor),
//             );
//           } else {
//             return TextSpan(
//               text: element,
//               style: TS.bodySmall.copyWith(color: primaryColor),
//               recognizer: TapGestureRecognizer()..onTap = onTap,
//             );
//           }
//         }).toList(),
//       ),
//     );
//   }
// }
