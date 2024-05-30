import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/config/environment_config.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/initial_route.dart';
// ignore: unused_import
import 'package:iroyal/base/utils/location/app_location.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:iroyal/base/utils/share/app_share.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/utils/token/app_token.dart';
import 'package:iroyal/firebase_options.dart';
import 'package:local_auth/local_auth.dart';

/// This is the main entry point of the app which performs any setups before
/// running the app.
Future<void> setupAndRunApp(
  Widget Function(EnvironmentConfig) appBuilder, {
  required EnvironmentConfig environment,
}) async {
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  // Configure global app tools before launching the app
  await configureApp(environment);

  // Build the widget
  final appWidget = appBuilder(environment);

  // Finally run the widget
  runApp(appWidget);
}

/// Configures application tools and packages before running the app. Services
/// such as Firebase or background handlers can be configured here.
Future configureApp(EnvironmentConfig envConfig) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await _setupNotifications();
  await Hive.initFlutter();
  AppConfig.environment = envConfig;

  final box = await Hive.openBox(IROYAL_STORAGE);
  final auth = LocalAuthentication();
  final dio = Dio();
  final alice = Alice(showNotification: false);
  final internetConnectionChecker = InternetConnectionChecker();
  final appDialogImpl = AppDialogImpl();
  Get
    ..put(alice)
    ..put(dio)
    ..put(AppStorage(box: box))
    ..put(NetworkInfoImpl(internetConnectionChecker))
    // ..put(AppLocationImpl())
    ..put(appDialogImpl)
    ..put(AppPermissionImpl())
    ..put(AppShareImpl())
    ..put(AuthBiometricsImpl(
        auth: auth, appDialog: appDialogImpl, appStorage: Get.find()))
    ..put(InitialRouteImpl(appStorage: Get.find()))
    ..put(AppEncryptImpl())
    ..put(
      HttpService(
        alice: alice,
        dio: Get.find(),
        appStorage: Get.find(),
        networkInfo: Get.find<NetworkInfoImpl>(),
        appEncrypt: Get.find<AppEncryptImpl>(),
      ),
    )
    ..put(
      AppTokenImpl(
        appStorage: Get.find(),
        http: Get.find(),
      ),
    );
  // ..put(CommonParamsImpl(appToken: Get.find<AppTokenImpl>()));
}

/// Configures Firebase notifications
Future<void> _setupNotifications() async {
  await FirebaseMessaging.instance.requestPermission();

  if (!kIsWeb) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }

  // In order to receive notifications when the app is in background or
  // terminated, you need to pass a callback to onBackgroundMessage method
  FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
}
