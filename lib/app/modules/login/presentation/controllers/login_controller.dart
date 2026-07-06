import 'dart:async';
import 'dart:io';
import 'package:android_id/android_id.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/login/data/models/login_params.dart';
import 'package:MyRoyal/app/modules/login/domain/usecases/auth_biometrics_login.dart';
import 'package:MyRoyal/app/modules/login/domain/usecases/get_cache_user_login.dart';
import 'package:MyRoyal/app/modules/login/domain/usecases/get_login_param.dart';
import 'package:MyRoyal/app/modules/login/domain/usecases/login_app.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/config/environment_config.dart';
import 'package:MyRoyal/base/initialization/firebase_remote_config.dart';
import 'package:MyRoyal/base/usecases/usecase.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/utils/biometrics.dart';
import 'package:MyRoyal/base/utils/dialog/app_dialog.dart';
import 'package:MyRoyal/base/utils/get_device_info.dart';
import 'package:MyRoyal/base/utils/storage/app_storage.dart';
import 'package:MyRoyal/base/utils/storage/app_device_id.dart';
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
    required this.envConfig,
  });

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
  final EnvironmentConfig envConfig;

  @override
  void onInit() async {
    super.onInit();

    await _setupDeviceInfo();
    await getCacheUser();
    await checkBiometricAuthentication();
    if (isAllowBiometrics.value == true) {
      biometricAuthentication();
    }
  }

  /// Setup device info (device ID, device user, etc.)
  Future<void> _setupDeviceInfo() async {
    String deviceUser = '';
    String deviceId = '';

    try {
      // Get Device Id iOS
      final info = await deviceInfo.info();

      // Get Android Id
      String? androidId = await AndroidId().getId();
      if (androidId == null || androidId.isEmpty || androidId == 'null') {
        androidId = await AppDeviceId.getDeviceId();
      }

      if (Platform.isAndroid) {
        deviceId = androidId;
        deviceUser = '${info.model}-${info.brand}-${androidId}';
      } else if (Platform.isIOS) {
        deviceId = info.id;
        deviceUser = '${info.model}-${info.brand}-${info.hardware}-${info.id}';
      }

      await appStorage.write('device-id', deviceId);
      await appStorage.write('device-user', deviceUser);

      AppUtils.logApp('[INFO] DEVICE ID :::: $deviceId');
      AppUtils.logApp('[INFO] DEVICE USER :::: $deviceUser');
    } catch (e) {
      AppUtils.logApp('[ERROR] Failed to setup device info: $e');
    }
  }

  void validateForm() {
    isValidForm(username.isNotEmpty && password.isNotEmpty);
  }

  void clear() {
    usernameController.clear();
    username.value = '';
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
          description: 'Silahkan isi Nama Pengguna dan Kata Sandi'));
      loginState = 'getParamsRejected';
      return;
    }
    final cacheFcmToken = await appStorage.read(CACHE_FCM_TOKEN);
    final deviceUser = await appStorage.read('device-user');
    final deviceId = await appStorage.read('device-id');
    final deviceUserParams = '${username()}-$deviceUser';
    final deviceIdParams = '${username()}-$deviceId';

    AppUtils.logApp('$cacheFcmToken');
    AppUtils.logApp('DEVICE USER :::: $deviceUserParams');

    isLoading(true);
    final r = await getLoginParams(
      ParamsLogin(
        grantType: 'password',
        clientId: envConfig.environment == EnvironmentType.production
            ? '9d6240c2-9c30-4b5e-97d2-c0a57a461190'
            : 'a137b23e-eb2f-4daa-b793-da58b4953f34',
        clientSecret: envConfig.environment == EnvironmentType.production
            ? 'K5JsI2WCZ5dIjQANC6xWx1WdwVUVftpgkCXFtl7W'
            : 'mUu7DvJCulddNkAFovTnlpEmDBACyAcNr4iRQeY5',
        username: username(),
        password: password(),
        scope: '*',
        fcmToken: cacheFcmToken.toString(),
        deviceId: deviceUser == '' || deviceUser == null
            ? deviceIdParams
            : deviceUserParams,
      ),
    );
    r.fold((l) {
      isLoading(false);
      loginState = 'getParamsFailed';
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
      AppUtils.logApp('LOGIN PARAMS ${loginParams().toJson()}');
    });
  }

  Future<void> login() async {
    final r = await loginApp(loginParams().toJson());
    r.fold(
      (l) {
        loginState = 'loginFailed';
      },
      (r) {
        loginState = 'loginSuccess';
        Get.offAllNamed(Routes.BOTTOMNAVBAR);
      },
    );
    isLoading(false);
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
        description: 'Silahkan login terlebih dahulu',
        textButton: 'Lanjut',
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
            ? 'Biometrik telah dinonaktifkan, harap aktifkan kembali agar dapat menggunakan biometrik.'
            : 'Biometrik belum diaktifkan, aktifkan biometrik di pengaturan handphone Anda.',
        textButton: 'Lanjut',
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
                'Biometrik belum diaktifkan, aktifkan biometrik di pengaturan handphone Anda.',
            textButton: 'Lanjut',
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

  Future<void> openWhatsApp(String phone) async {
    final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phone");
    final Uri waMeUri = Uri.parse("https://wa.me/$phone");
    final Uri telUri = Uri.parse("tel:$phone");

    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
        return;
      }

      if (await canLaunchUrl(waMeUri)) {
        await launchUrl(waMeUri, mode: LaunchMode.externalApplication);
        return;
      }

      if (await canLaunchUrl(telUri)) {
        await launchUrl(telUri);
        return;
      }

      throw "No available action";
    } catch (e) {
      debugPrint("Error launching: $e");
    }
  }

  // Navigation
  void gotoForgotPassword() {
    appDialog.showForgotPasswordDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description: 'Silahkan hubungi departemen IT untuk bantuan lebih lanjut.',
      phoneNumber: '0811-2465-515',
      phoneNumber2: '0811-2000-5071',
      textButton: 'Lanjut',
      onPressPhone1: () => openWhatsApp('0811-2465-515'),
      onPressPhone2: () => openWhatsApp('0811-2000-5071'),
    );
  }

  // Dont have an Account
  void dontHaveAnAccount() {
    appDialog.showForgotPasswordDialog(
      imagePath: 'assets/icons/ic_information.svg',
      description: 'Silahkan hubungi departemen IT untuk bantuan lebih lanjut.',
      phoneNumber: '0811-2465-515',
      phoneNumber2: '0811-2000-5071',
      textButton: 'Lanjut',
      onPressPhone1: () => openWhatsApp('0811-2465-515'),
      onPressPhone2: () => openWhatsApp('0811-2000-5071'),
    );
  }
}
