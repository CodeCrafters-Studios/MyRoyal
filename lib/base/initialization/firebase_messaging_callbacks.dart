// Copyright (c) 2023, Prime Holding JSC
// https://www.primeholding.com
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/widgets/others/coming_soon.dart';
import 'package:url_launcher/url_launcher.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Callback executed once the app receives a FCM message while in foreground
Future<void> onForegroundMessage(
  BuildContext context,
  RemoteMessage message,
) async {
  log('Foreground Message received!');
  final notification = message.notification;
  final data = message.data;

  AppUtils.logApp('FCM DATA :::: $data');

  if (notification != null) {
    final androidNotification = notification.android;

    // Present the foreground notification on Android only
    // https://firebase.flutter.dev/docs/messaging/notifications/#application-in-foreground
    if (!kIsWeb && androidNotification != null) {
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: false,
      );
      const platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0, // notification id
        notification.title,
        notification.body,
        platformChannelSpecifics,
        payload: data["route"],
      );
    }
  }
}

@pragma('vm:entry-point')
void onDidReceiveBackgroundNotificationResponse(
    NotificationResponse notificationResponse) async {
  log('Background Message received!');
  if (notificationResponse.payload != null) {
    final route = notificationResponse.payload;

    if (route.toString().contains('https://')) {
      final uri = Uri.parse(route!);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        AppUtils.logApp('Could not launch $route');
      }
    } else {
      switch (notificationResponse.payload) {
        case 'My Teams':
          Get.toNamed(Routes.MY_TEAMS);
          break;
        case 'Webtel':
          Get.toNamed(Routes.WEBTEL);
          break;
        case 'Tracking Documents':
          Get.toNamed(Routes.TRACKING_DOCUMENT);
          break;
        case 'Tasks':
          Get.toNamed(Routes.TASKS);
          break;
        case 'Payroll':
          Get.toNamed(Routes.PIN);
          break;
        case 'Dashboard':
          Get.toNamed(Routes.DASHBOARD);
          break;
        case 'Visit':
          Get.toNamed(Routes.VISIT);
          break;
        default:
          Get.to(() => const ComingSoonScreen());
          break;
      }
    }
  } else {
    AppUtils.logApp('ROUTE IS EMPTY');
  }
}

/// Callback executed once the app receives a FCM message while in background
/// or when the app is terminated. Note here that no build context is provided,
/// as the app is running in headless state (without a GUI).
@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  //If using other Firebase services, make sure that the Firebase is initialized
  await Firebase.initializeApp();
  final data = message.data;

  log('On Background Message ::: $data');
}

/// Callback executed if the app has opened from a background state (and was
/// not terminated).
Future<void> onMessageOpenedFromBackground(
  BuildContext context,
  RemoteMessage message,
) async {
  final data = message.data;

  log('Message opened from background. ::: $data');

  if (data.isNotEmpty) {
    final route = data['route'];

    if (route.toString().contains('https://')) {
      final uri = Uri.parse(route!);
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } else if (!route.toString().contains('/storage')) {
      switch (route) {
        case 'My Teams':
          Get.toNamed(Routes.MY_TEAMS);
          break;
        case 'Webtel':
          Get.toNamed(Routes.WEBTEL);
          break;
        case 'Tracking Documents':
          Get.toNamed(Routes.TRACKING_DOCUMENT);
          break;
        case 'Tasks':
          Get.toNamed(Routes.TASKS);
          break;
        case 'Payroll':
          Get.toNamed(Routes.PIN);
          break;
        case 'Dashboard':
          Get.toNamed(Routes.DASHBOARD);
          break;
        case 'Visit':
          Get.toNamed(Routes.VISIT);
          break;
        default:
          Get.to(() => const ComingSoonScreen());
          break;
      }
    }
  } else {
    AppUtils.logApp('ROUTE IS EMPTY');
  }
}

/// If the application has been opened from a terminated state via a remote
/// message (containing a notification), it will be returned, otherwise it will
/// be `null`.
Future<void> onInitialMessageOpened(
  BuildContext context,
  RemoteMessage? message,
) async {
  log('Initial message exists: ${message != null}');
}

/// Callback triggered once a new FCM token is generated
Future<void> onFCMTokenRefresh(BuildContext context, String token) async {
  // final box = await Hive.openBox(IROYAL_STORAGE);
  // AppStorage appStorage = AppStorage(box: box);
  // await appStorage.write(CACHE_FCM_TOKEN, token);
  log('New FCM token: $token');
}

void onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  if (notificationResponse.payload != null &&
      notificationResponse.payload != '') {
    final route = notificationResponse.payload;
    final uri = Uri.parse(route!);

    AppUtils.logApp('HERE 2 $route');

    if (route.toString().contains('https://')) {
      if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
      }
    } else if (!route.toString().contains('/storage')) {
      switch (notificationResponse.payload) {
        case 'My Teams':
          Get.toNamed(Routes.MY_TEAMS);
          break;
        case 'Webtel':
          Get.toNamed(Routes.WEBTEL);
          break;
        case 'Tracking Documents':
          Get.toNamed(Routes.TRACKING_DOCUMENT);
          break;
        case 'Tasks':
          Get.toNamed(Routes.TASKS);
          break;
        case 'Payroll':
          Get.toNamed(Routes.PIN);
          break;
        case 'Dashboard':
          Get.toNamed(Routes.DASHBOARD);
          break;
        case 'Visit':
          Get.toNamed(Routes.VISIT);
          break;
        default:
          Get.to(() => const ComingSoonScreen());
          break;
      }
    }
  } else {
    AppUtils.logApp('ROUTE IS EMPTY');
  }
}
