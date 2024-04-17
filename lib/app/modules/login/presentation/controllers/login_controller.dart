import 'dart:async';

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
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

enum FormLoginValue { username, password }

class LoginController extends GetxController {
  LoginController({
    required this.appDialog,
    required this.getLoginParams,
    required this.loginApp,
    required this.getCacheUserLogin,
    required this.authBiometricsLogin,
  });

  String loginState = '';

  Rx<LoginParamsModel> loginParams = const LoginParamsModel().obs;

  RxString username = ''.obs;
  RxString password = ''.obs;

  RxBool isValidForm = false.obs;
  RxBool isLoading = false.obs;
  RxBool isCacheuser = false.obs;

  final AppDialog appDialog;
  final GetLoginParams getLoginParams;
  final LoginApp loginApp;
  final GetCacheUserLogin getCacheUserLogin;
  final AuthBiometricsLogin authBiometricsLogin;

  @override
  void onInit() {
    getCacheUser();
    super.onInit();
  }

  void validateForm() {
    isValidForm(username.isNotEmpty && password.isNotEmpty);
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
          description: 'Info yang kamu masukan tidak sesuai.'));
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
        Get.offAllNamed(Routes.HOME);
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
      return;
    }
    final r = await authBiometricsLogin(NoParams());
    r.fold((l) => loginState = 'biometricsFailed', (r) {
      if (r) {
        loginState = 'biometricsSuccess';
        loginWithCacheUser();
      } else {
        loginState = 'biometricsFailed';
      }
    });
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

  //Navigation
  void gotoForgotPassword() {}

  void gotoRegister() {}
}
