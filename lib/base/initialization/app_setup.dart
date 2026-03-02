import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:iroyal/base/config/app_config.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/config/environment_config.dart';
import 'package:iroyal/base/data/app_encryption.dart';
import 'package:iroyal/base/initialization/firebase_remote_config.dart';
import 'package:iroyal/base/services/http_service.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/biometrics.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';
import 'package:iroyal/base/utils/get_device_info.dart';
import 'package:iroyal/base/utils/initial_route.dart';
import 'package:iroyal/base/utils/location/app_location.dart';
import 'package:iroyal/base/utils/network/network_info.dart';
import 'package:iroyal/base/utils/permission/app_permission.dart';
import 'package:iroyal/base/utils/share/app_share.dart';
import 'package:iroyal/base/utils/storage/app_storage.dart';
import 'package:iroyal/base/utils/token/app_token.dart';
import 'package:iroyal/firebase_options.dart';
import 'package:local_auth/local_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// This is the main entry point of the app which performs any setups before
/// running the app.
Future<void> setupAndRunApp(
  Widget Function(EnvironmentConfig) appBuilder, {
  required EnvironmentConfig environment,
}) async {
  // enableFlutterDriverExtension();
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  // Configure global app tools before launching the app
  await configureApp(environment);

  // Build the widget
  final appWidget = appBuilder(environment);

  // Finally run the widget
  FirebaseMessaging.onBackgroundMessage(remoteMessageHandler);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

  await FlutterDownloader.initialize(
    debug: environment.environment == EnvironmentType.production ? false : true,
    ignoreSsl: true,
  );

  runApp(
    environment.environment == EnvironmentType.production
        ? appWidget
        : DioRequestInspectorMain(
            inspector: DioRequestInspector(isInspectorEnabled: true),
            child: appWidget,
          ),
  );
}

Future<void> remoteMessageHandler(RemoteMessage message) async {
  AppUtils.logApp('REMOTE MESSAGE HANDLER');
  AppUtils.logApp('${message.data}');
}

/// Configures application tools and packages before running the app. Services
/// such as Firebase or background handlers can be configured here.
Future configureApp(EnvironmentConfig envConfig) async {
  await Firebase.initializeApp(
    name: envConfig.environment == EnvironmentType.production
        ? "MyRoyal"
        : "MyRoyal-Dev",
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await MellotippetFirebaseRemoteConfig.initialize();
  await Hive.initFlutter();
  await _setupNotifications();
  AppConfig.environment = envConfig;

  final box = await Hive.openBox(IROYAL_STORAGE);
  final deviceInfoPlugin = DeviceInfoPlugin();
  final packageInfo = await PackageInfo.fromPlatform();
  final auth = LocalAuthentication();
  final dio = Dio();
  final inspector = DioRequestInspector(isInspectorEnabled: true);
  final internetConnectionChecker = InternetConnectionChecker.createInstance();
  final appDialogImpl = AppDialogImpl();
  final Connectivity connectivity = Connectivity();
  final firebaseRemoteConfig = MellotippetFirebaseRemoteConfig();

  Get
    ..put(AppConfig.environment)
    ..put(dio)
    ..put(box)
    ..put(inspector)
    ..put(AppStorage(box: box))
    ..put(
      DeviceInfo(
        deviceInfoPlugin: deviceInfoPlugin,
        packageInfo: packageInfo,
      ),
    )
    ..put(NetworkInfoImpl(internetConnectionChecker))
    ..put(AppLocationImpl())
    ..put(appDialogImpl)
    ..put(AppPermissionImpl())
    ..put(AppShareImpl())
    ..put(AuthBiometricsImpl(
        auth: auth, appDialog: appDialogImpl, appStorage: Get.find()))
    ..put(InitialRouteImpl(appStorage: Get.find()))
    ..put(AppEncryptImpl())
    ..put(
      HttpService(
        dio: Get.find(),
        inspector: Get.find(),
        appStorage: Get.find(),
        networkInfo: Get.find<NetworkInfoImpl>(),
        appEncrypt: Get.find<AppEncryptImpl>(),
        connectivity: connectivity,
      ),
    )
    ..put(
      AppTokenImpl(
        appStorage: Get.find(),
        http: Get.find(),
      ),
    )
    ..put(connectivity)
    ..put(firebaseRemoteConfig);
  // ..put(CommonParamsImpl(appToken: Get.find<AppTokenImpl>()));
}

/// Configures Firebase notifications
Future<void> _setupNotifications() async {
  final box = await Hive.openBox(IROYAL_STORAGE);
  AppStorage appStorage = AppStorage(box: box);

  await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getToken().then((token) async {
    String fcmToken = token.toString();
    await appStorage.write(CACHE_FCM_TOKEN, fcmToken);

    AppUtils.logApp('[FIREBASE] FCM TOKEN :::: $fcmToken');
  });

  if (!kIsWeb) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
}
