import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:dio_request_inspector/dio_request_inspector.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/bindings/initial_binding.dart';
import 'package:MyRoyal/app/routes/app_pages.dart';
import 'package:MyRoyal/base/config/app_constants.dart';
import 'package:MyRoyal/base/config/environment_config.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/initialization/firebase_messaging_callbacks.dart';
import 'package:MyRoyal/base/utils/app_utils.dart';
import 'package:MyRoyal/base/widgets/others/overlay_log_button.dart';
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
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _hideSystemUI();
    });

    _configureFCM();
    _requestNotificationPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _hideSystemUI() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
      overlays: [],
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
    );
  }

  Future<void> _configureFCM() async {
    if (!kIsWeb && Platform.isIOS && (await _isIosSimulator())) {
      AppUtils.logApp(
          '[FIREBASE] Skipping FCM configuration on iOS Simulator.');
      return;
    }

    try {
      final topicName = widget.config == const EnvironmentConfig.production()
          ? 'All'
          : 'All_Dev';

      await FirebaseMessaging.instance.getInitialMessage();

      await FirebaseMessaging.instance.subscribeToTopic(topicName);

      final oppositeTopic = topicName == 'All' ? 'All_Dev' : 'All';
      await FirebaseMessaging.instance.unsubscribeFromTopic(oppositeTopic);

      FirebaseMessaging.instance.onTokenRefresh.listen(
        (token) => onFCMTokenRefresh(context, token),
      );

      FirebaseMessaging.onMessage.listen(
        (message) => onForegroundMessage(context, message),
      );

      FirebaseMessaging.onMessageOpenedApp.listen(
        (message) => onMessageOpenedFromBackground(context, message),
      );
    } catch (e) {
      AppUtils.logApp('[FIREBASE] Error configuring FCM: $e');
    }
  }

  /// Returns true when the app is running inside an iOS simulator.
  Future<bool> _isIosSimulator() async {
    if (kIsWeb || !Platform.isIOS) return false;
    try {
      final deviceInfo = DeviceInfoPlugin();
      final iosInfo = await deviceInfo.iosInfo;
      return !iosInfo.isPhysicalDevice;
    } catch (_) {
      return false;
    }
  }

  Future<void> _openFile(String filePath) async {
    final result = await OpenFilex.open(filePath);

    if (result.type != ResultType.done) {
      AppUtils.logApp("Failed to open file: ${result.message}");
    }
  }

  Future<void> _requestNotificationPermissions() async {
    try {
      const initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      );

      await flutterLocalNotificationsPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {
          final payload = notificationResponse.payload;

          if (payload == null || payload.isEmpty) return;

          if (payload.startsWith("content://")) {
            final intent = AndroidIntent(
              action: 'action_view',
              data: payload,
              flags: <int>[Flag.FLAG_GRANT_READ_URI_PERMISSION],
              type: 'application/pdf',
            );
            await intent.launch();
            return;
          }

          await _openFile(payload);
        },
        onDidReceiveBackgroundNotificationResponse:
            onDidReceiveBackgroundNotificationResponse,
      );

      if (Platform.isAndroid) {
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()
            ?.requestNotificationsPermission();
      }

      if (Platform.isIOS) {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          badge: true,
          sound: true,
        );
      }
    } catch (e) {
      AppUtils.logApp('[NOTIFICATIONS] Error requesting permissions: $e');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _hideSystemUI();
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
    _hideSystemUI();

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
