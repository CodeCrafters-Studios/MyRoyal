import 'package:alice/alice.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/bindings/initial_binding.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/config/app_constants.dart';
import 'package:iroyal/base/config/environment_config.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:iroyal/base/widgets/others/overlay_log_button.dart';

class BaseApp extends StatelessWidget {
  const BaseApp({
    this.config = const EnvironmentConfig.production(),
    super.key,
  });

  final EnvironmentConfig config;

  @override
  Widget build(BuildContext context) => ScreenUtilInit(
        useInheritedMediaQuery: true,
        designSize: designSize,
        minTextAdapt: true,
        builder: (context, child) => const App(),
      );
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    // Initialize flutter_local_notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );

    _configureFCM();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  Future<void> _configureFCM() async {
    /// Initialize the FCM callbacks
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (!mounted) return;
    await onInitialMessageOpened(context, initialMessage);

    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        break;
      case AppLifecycleState.inactive:
        // widget is inactive
        break;
      case AppLifecycleState.paused:
        // widget is paused
        break;
      case AppLifecycleState.detached:
        // widget is detached
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: Get.find<Alice>().getNavigatorKey(),
      navigatorObservers: [GetObserver()],
      title: appTitle,
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      builder: (BuildContext context, Widget? child) {
        return Stack(
          children: [
            child!,
            OverlayLogButton(
              onTap: () {
                Get.find<Alice>().showInspector();
              },
            ),
          ],
        );
      },
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      initialRoute: Routes.SPLASH,
      // locale: const Locale('id_ID'),
      // translationsKeys: AppTranslation.translations,
    );
  }
}
