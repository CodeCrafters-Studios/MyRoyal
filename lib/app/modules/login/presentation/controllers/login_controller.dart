import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/login/data/models/login_params.dart';
import 'package:iroyal/app/modules/login/domain/usecases/auth_biometrics_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_login_param.dart';
import 'package:iroyal/app/modules/login/domain/usecases/login_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/usecases/usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';

enum FormLoginValue { username, password }

class LoginController extends GetxController {
  LoginController({
    required this.appDialog,
    required this.getLoginParams,
    required this.loginApp,
    required this.getCacheUserLogin,
    required this.authBiometricsLogin,
    required this.appStorage,
    required this.authBiometrics,
  });

  final FocusNode focusNodeUsername = FocusNode();

  TextEditingController usernameController = TextEditingController();

  String loginState = '';

  Rx<LoginParamsModel> loginParams = const LoginParamsModel().obs;

  RxString username = ''.obs;
  RxString password = ''.obs;

  RxBool isValidForm = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCacheuser = false.obs;
  RxBool isAllowBiometrics = false.obs;
  RxBool getAvailableBiometrics = false.obs;
  RxBool isFocus = false.obs;

  final AppDialog appDialog;
  final GetLoginParams getLoginParams;
  final LoginApp loginApp;
  final GetCacheUserLogin getCacheUserLogin;
  final AuthBiometricsLogin authBiometricsLogin;
  final AppStorage appStorage;
  final AuthBiometrics authBiometrics;

  @override
  void onInit() async {
    focusNodeUsername.addListener(_onFocusChange);
    AppUtils.logApp(
        'FOCUS :::::::::$focusNodeUsername.addListener(_onFocusChange);');
    await getCacheUser();
    await checkBiometricAuthentication();
    if (isAllowBiometrics.value == true) {
      AppUtils.logApp('BIO :::::::::TRUE');
      AppUtils.logApp('${isAllowBiometrics.value}');
      biometricAuthentication();
    } else {
      AppUtils.logApp('BIO :::::::::FALSE');
      null;
    }
    super.onInit();
  }

  @override
  void dispose() {
    focusNodeUsername.removeListener(_onFocusChange);
    focusNodeUsername.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (focusNodeUsername.hasFocus == false) {
      isFocus(false);
    } else {
      isFocus(true);
    }
  }

  void validateForm() {
    isValidForm(username.isNotEmpty && password.isNotEmpty);
  }

  void clear() {
    usernameController.clear();
  }

  void setLoginValue(FormLoginValue key, String value) {
    switch (key) {
      case FormLoginValue.username:
        username(value);
        validateForm();
        break;
      case FormLoginValue.password:
        password(value);
        validateForm();
        break;
    }
  }

  Future<void> getParams() async {
    AppUtils.logApp(username());
    AppUtils.logApp(password());
    if (!isValidForm()) {
      unawaited(appDialog.showErrorSnackBar(
          description: 'Please input Username and Password'));
      loginState = 'getParamsRejected';
      return;
    }
    isLoading(true);
    final r = await getLoginParams(
      ParamsLogin(
        grantType: "password",
        username: username(),
        password: password(),
        clientId: "H4K3aPzo1VXD8JwTj7AHSayJ1fOQfUmZwSMpDu7uKmM",
        clientSecret: "dYr3QnrIqgmflANWZLfWg3Qgh-A1dNHssQ9KprP3DTE",
      ),
    );
    r.fold((l) {
      isLoading(false);
      loginState = 'getParamsFailed';
      appDialog.showErrorDialog();
    }, (r) {
      loginState = 'getParamsSuccess';
      loginParams(
        LoginParamsModel(
          grantType: r.grantType,
          username: r.username,
          password: r.password,
          clientId: r.clientId,
          clientSecret: r.clientSecret,
        ),
      );
      login();
    });
  }

  Future<void> login() async {
    final r = await loginApp(loginParams().toJson());
    isLoading(false);
    r.fold(
      (l) {
        loginState = 'loginFailed';
        final m = l.properties[0] as ApiException;
        appDialog.showErrorDialog(description: m.message);
      },
      (r) {
        loginState = 'loginSuccess';
        Get.offAllNamed(Routes.BOTTOMNAVBAR);
      },
    );
  }

  Future<void> getCacheUser() async {
    final r = await getCacheUserLogin(NoParams());
    r.fold((l) {
      loginState = 'getCacheUserFailed';
    }, (r) {
      loginState = 'getCacheUserSuccess';
      isCacheuser(r.username.isNotEmpty && r.password.isNotEmpty);
    });
  }

  Future<void> biometricAuthentication() async {
    if (!isCacheuser()) {
      loginState = 'biometricsRejected';
      appDialog.showInfoDialog(
        imagePath: 'assets/icons/ic_information.svg',
        description: 'Please login first',
        textButton: 'Continue',
      );
      AppUtils.logApp('ERROR');
      return;
    }
    await authBiometrics.isSupported();
    await checkBiometricAuthentication();
    if (isAllowBiometrics.value == false) {
      AppUtils.logApp('HERE FALSE');
      AppUtils.logApp('GET AVAILABLE :::: ${getAvailableBiometrics.value}');
      appDialog.showInfoDialog(
        imagePath: 'assets/icons/ic_information.svg',
        description: getAvailableBiometrics.value == true
            ? 'Biometrics has disabled, please set to enable to using biometrics'
            : 'Biometrics is not set, please configure biometrics security on your phone.',
        textButton: 'Continue',
      );

      return;
    }
    final r = await authBiometricsLogin(NoParams());
    r.fold(
      (l) {
        loginState = 'biometricsFailed';
        if (l.properties.isEmpty) {
          AppUtils.logApp('CANCEL BIO:::::::');
        } else {
          // Handle Biometrics is not configuration on device user

          appDialog.showInfoDialog(
            imagePath: 'assets/icons/ic_information.svg',
            description:
                'Biometrics is not set, please configure biometrics security on your phone.',
            textButton: 'Continue',
          );
          AppUtils.logApp('FAILURE::::::: ${l.properties.length}');
        }
        AppUtils.logApp('ERROR NOT SUPP / CANCEL / DISABLE SETTING BIOMETRICS');
      },
      (r) {
        if (r) {
          loginState = 'biometricsSuccess';

          loginWithCacheUser();
        } else {
          loginState = 'biometricsFailed';
        }
      },
    );
  }

  Future<void> loginWithCacheUser() async {
    final r = await getCacheUserLogin(NoParams());
    r.fold((l) => loginState = 'biometricsRejected', (r) {
      loginState = 'biometricsSuccess';
      username(r.username);
      password(r.password);
      validateForm();
      getParams();
    });
  }

  Future<void> checkBiometricAuthentication() async {
    final isAllowedBiometrics =
        await appStorage.read('switch-biometrics-value');
    final checkAvailableBiometrics =
        await appStorage.read('get-available-biometrics');

    AppUtils.logApp('CEKK AVAIL $checkAvailableBiometrics');

    if (checkAvailableBiometrics == 'true') {
      AppUtils.logApp('AVAILABLE');
      getAvailableBiometrics.value = true;
    } else {
      AppUtils.logApp('UNAVAILABLE');
      getAvailableBiometrics.value = false;
    }

    AppUtils.logApp('IS ALLOW BIO VALUE :::::::$isAllowedBiometrics');
    if (isAllowedBiometrics == 'true') {
      isAllowBiometrics.value = true;
    } else {
      isAllowBiometrics.value = false;
    }
  }

  // Navigation
  void gotoForgotPassword() {
    appDialog.showInfoDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description:
          'Please contact the IT Department\nfor further assistance.\n\nCall 021-2345-6789',
      textButton: 'Continue',
    );
  }

  // Dont have an Account
  void dontHaveAnAccount() {
    appDialog.showInfoDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description:
          'Please contact the IT Department\nfor further assistance.\n\nCall 021-2345-6789',
      textButton: 'Continue',
    );
  }
}
