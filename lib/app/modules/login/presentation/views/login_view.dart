import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/login/presentation/views/components/biometric_login.dart';
import 'package:MyRoyal/app/modules/login/presentation/views/components/have_no_account.dart';
import 'package:MyRoyal/app/modules/login/presentation/views/components/or_login_with.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/app_images/logo.dart';
import 'package:MyRoyal/base/widgets/buttons/button_primary.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';
import 'package:MyRoyal/base/widgets/textfield/input_password.dart';
import 'package:MyRoyal/base/widgets/textfield/input_primary.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackgroundLogin: true,
      appBar: const SizedBox.shrink(),
      resizeInsetsBottom: true,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            80.verticalSpace,
            _buildLogo(),
            12.verticalSpace,
            Text(
              'MyRoyal',
              style: TS.titleMedium.copyWith(
                color: primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
            4.verticalSpace,
            Text(
              'Masuk ke akun Anda',
              style: TS.bodySmall.copyWith(color: greyText),
            ),
            32.verticalSpace,
            // Glassmorphism form card
            _buildFormCard(context),
            24.verticalSpace,
            Obx(
              () => ButtonPrimary(
                margin: REdgeInsets.symmetric(horizontal: 24),
                key: const Key('loginBtn'),
                onPressed: controller.getParams,
                isLoading: controller.isLoading.value,
                text: 'Masuk',
                fullWidth: true,
                borderRadius: 14,
              ),
            ),
            24.verticalSpace,
            EPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: const OrLoginWith(),
            ),
            20.verticalSpace,
            BiometricsLogin(
              key: const Key('loginBiometrics'),
              onTap: controller.biometricAuthentication,
            ),
            16.verticalSpace,
            HaveNoAccount(
              key: const Key('loginNoAccount'),
              onTap: controller.dontHaveAnAccount,
            ),
            16.verticalSpace,
            Text(
              'Version ${controller.deviceInfo.packageInfo.version}',
              style: TS.caption.copyWith(color: greyText),
              textAlign: TextAlign.center,
            ),
            32.verticalSpace,
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: primary.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 4,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: const Logo(),
    );
  }

  Widget _buildFormCard(BuildContext context) {
    return Padding(
      padding: REdgeInsets.symmetric(horizontal: 24),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: REdgeInsets.all(20),
            decoration: BoxDecoration(
              color: inputColor.withOpacity(0.88),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: white.withOpacity(0.6),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: primary.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Nama Pengguna',
                  style: TS.labelMedium.copyWith(color: appTextColor),
                ),
                6.verticalSpace,
                Obx(
                  () => InputPrimary(
                    controller: controller.usernameController,
                    key: const Key('inputUsername'),
                    label: '',
                    hint: 'Masukkan nama pengguna',
                    onChanged: (value) => controller.setLoginValue(
                      FormLoginValue.username,
                      value.toLowerCase(),
                    ),
                    validation: (value) => value?.isEmpty ?? false
                        ? 'Nama pengguna tidak boleh kosong'
                        : null,
                    prefixIcon: EPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: ImageIcon(
                        const AssetImage('assets/icons/ic_user.png'),
                        size: 18.r,
                        color: greyText,
                      ),
                    ),
                    suffixIcon: controller.username.value.isNotEmpty
                        ? IconButton(
                            onPressed: controller.clear,
                            icon: Icon(
                              Icons.clear,
                              color: greyText,
                              size: 16.r,
                            ),
                          )
                        : null,
                    color: white,
                    borderRadius: 12,
                  ),
                ),
                14.verticalSpace,
                InputPassword(
                  key: const Key('inputPassword'),
                  hint: 'Masukkan kata sandi',
                  onChanged: (value) => controller.setLoginValue(
                    FormLoginValue.password,
                    value,
                  ),
                  validation: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Kata sandi tidak boleh kosong';
                    } else if (value.length < 6) {
                      return 'Kata sandi harus setidaknya 6 karakter';
                    }
                    return null;
                  },
                  prefixIcon: EPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: ImageIcon(
                      const AssetImage('assets/icons/ic_lock.png'),
                      size: 18.r,
                      color: greyText,
                    ),
                  ),
                  color: white,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      key: const Key('loginForgotPassword'),
                      onPressed: controller.gotoForgotPassword,
                      child: Text(
                        'Lupa kata sandi?',
                        style: TS.bodySmall.copyWith(
                          color: secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
