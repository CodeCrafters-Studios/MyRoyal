import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/login/data/models/login_params.dart';
import 'package:iroyal/app/modules/login/domain/usecases/auth_biometrics_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_cache_user_login.dart';
import 'package:iroyal/app/modules/login/domain/usecases/get_login_param.dart';
import 'package:iroyal/app/modules/login/domain/usecases/login_app.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/initialization/firebase_remote_config.dart';
import 'package:iroyal/base/usecases/usecase.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:url_launcher/url_launcher.dart';

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
    required this.deviceInfo,
    required this.firebaseRemoteConfig,
  });

  final FocusNode focusNodeUsername = FocusNode();

  TextEditingController usernameController = TextEditingController();

  String loginState = '';

  Rx<LoginParamsModel> loginParams = const LoginParamsModel().obs;

  RxString grantType = ''.obs;
  RxString clientId = ''.obs;
  RxString clientSecret = ''.obs;
  RxString username = ''.obs;
  RxString password = ''.obs;
  RxString scope = ''.obs;
  RxString fcmToken = ''.obs;

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
  final DeviceInfo deviceInfo;
  final MellotippetFirebaseRemoteConfig firebaseRemoteConfig;

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
    checkVersion();
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

  void checkVersion() async {
    // Get the current app version
    final appVersion =
        _getExtendedVersionNumber(deviceInfo.packageInfo.version);

    // Get Device Id
    final info = await deviceInfo.info();
    await appStorage.write('device-id', info.id);

    // Get the required min version from Firebase Remote Config
    final requiredMinVersion = _getExtendedVersionNumber(
        firebaseRemoteConfig.getRequiredMinimumVersion());

    // Get the recommended min version from Firebase Remote Config
    final recommendedMinVersion = _getExtendedVersionNumber(
        firebaseRemoteConfig.getRecommendedMinimumVersion());

    final forceUpdateVersion = firebaseRemoteConfig.getForceUpdateVersion();

    AppUtils.logApp('APP VERSION :::: $appVersion');
    AppUtils.logApp('APP VERSION REQUIRED :::: $requiredMinVersion');
    AppUtils.logApp('APP VERSION RECOMMENDED :::: $recommendedMinVersion');
    AppUtils.logApp('APP VERSION FORCE UPDATE :::: $forceUpdateVersion');
    // Compare the versions and display a dialog if the app version is lower than
    // the required or recommended version
    if (appVersion < requiredMinVersion) {
      _showUpdateVersionDialog(forceUpdateVersion);
    } else if (appVersion < recommendedMinVersion) {
      _showUpdateVersionDialog(forceUpdateVersion);
    } else {
      emptyBox;
    }
  }

  // Helper method to compare two semver versions.
  int _getExtendedVersionNumber(String version) {
    List<String> versionCells = version.split('.');
    List<int> versionNumbers = versionCells.map((i) => int.parse(i)).toList();

    return versionNumbers[0] * 100000 +
        versionNumbers[1] * 1000 +
        versionNumbers[2];
  }

  void _showUpdateVersionDialog(bool isForceUpdateVersion) {
    appDialog.showAppVersionInfoDialog(
        isForceUpdateVersion: isForceUpdateVersion,
        title: 'New version available',
        description:
            'There is a new version available in the Google Play Store. Would you like to update?',
        onPressLater: Get.back,
        onPressUpdate: () async {
          String url =
              "https://play.google.com/store/apps/details?id=com.iroyal";
          if (await canLaunchUrl(Uri.parse(url))) {
            await launchUrl(Uri.parse(url),
                mode: LaunchMode.externalApplication);
          } else {
            throw 'Could not launch $url';
          }
        });
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
    final cacheFcmToken = await appStorage.read(CACHE_FCM_TOKEN);
    final deviceId = await appStorage.read('device-id');
    AppUtils.logApp('$cacheFcmToken');

    isLoading(true);
    final r = await getLoginParams(
      /* -- PRODUCTION -- */
      ParamsLogin(
        grantType: 'password',
        clientId: '9d6240c2-9c30-4b5e-97d2-c0a57a461190',
        clientSecret: 'K5JsI2WCZ5dIjQANC6xWx1WdwVUVftpgkCXFtl7W',
        username: username(),
        password: password(),
        scope: '*',
        fcmToken: cacheFcmToken.toString(),
        deviceId: deviceId.toString(),
      ),

      /* -- DEVELOPMENT -- */
      // ParamsLogin(
      //   grantType: 'password',
      //   clientId: '9e069d0f-2a06-4e0b-a9fe-cff32a262371',
      //   clientSecret: 'o9nbgKJMRUvEJw8AZbAwVZdGrcOZEpBjLHiOMoYN',
      //   username: username(),
      //   password: password(),
      //   scope: '*',
      //   fcmToken: cacheFcmToken.toString(),
      //   deviceId: deviceId.toString(),
      // ),
    );
    r.fold((l) {
      isLoading(false);
      loginState = 'getParamsFailed';
      final m = l.properties[0] as ApiException;
      appDialog.showErrorDialog(description: m.message);
    }, (r) {
      loginState = 'getParamsSuccess';
      loginParams(LoginParamsModel(
        grantType: r.grantType,
        clientId: r.clientId,
        clientSecret: r.clientSecret,
        username: r.username,
        password: r.password,
        scope: r.scope,
        fcmToken: r.fcmToken,
        deviceId: r.deviceId,
      ));
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
      grantType(r.grantType);
      clientId(r.clientId);
      clientSecret(r.clientSecret);
      username(r.username);
      password(r.password);
      scope(r.scope);
      fcmToken(r.fcmToken);
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
          'Please contact the IT Department\nfor further assistance.\n\nCall 0811-2465-515 or 0811-2000-5071',
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
