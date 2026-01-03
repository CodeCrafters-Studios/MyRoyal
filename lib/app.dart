import 'package:dio_request_inspector/dio_request_inspector.dart';
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
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/others/overlay_log_button.dart';
import 'package:open_filex/open_filex.dart';

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
        builder: (context, child) => App(config: config),
      );
}

class App extends StatefulWidget {
  const App({super.key, required this.config});

  final EnvironmentConfig config;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    _configureFCM();
    _requestNotificationPermissions();

    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> _configureFCM() async {
    /// Initialize the FCM callbacks
    await FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.instance.subscribeToTopic('All');
    FirebaseMessaging.instance.onTokenRefresh
        .listen((token) => onFCMTokenRefresh(context, token));
    FirebaseMessaging.onMessage
        .listen((message) => onForegroundMessage(context, message));
    FirebaseMessaging.onMessageOpenedApp
        .listen((message) => onMessageOpenedFromBackground(context, message));
  }

  Future<void> _openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type != ResultType.done) {
      AppUtils.logApp("Failed to open file: ${result.message}");
    }
  }

  Future<void> _requestNotificationPermissions() async {
    // Initialize flutter_local_notifications
    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const initializationSettings =
        InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        final payload = notificationResponse.payload;
        if (payload != null && payload.isNotEmpty) {
          _openFile(payload);
        }
        onDidReceiveNotificationResponse(notificationResponse);
      },
      onDidReceiveBackgroundNotificationResponse:
          onDidReceiveBackgroundNotificationResponse,
    );
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()!
        .requestNotificationsPermission();
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
      navigatorObservers: [
        GetObserver(),
        DioRequestInspector.navigatorObserver,
      ],
      title: appTitle,
      theme: appTheme(context),
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      builder: (BuildContext context, Widget? child) {
        return widget.config != const EnvironmentConfig.production()
            ? Banner(
                message: 'DEV',
                location: BannerLocation.topStart,
                child: Stack(
                  children: [
                    child!,
                    OverlayLogButton(
                      onTap: () =>
                          Get.find<DioRequestInspector>().goToInspector(),
                    ),
                  ],
                ),
              )
            : Stack(
                children: [child!],
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
