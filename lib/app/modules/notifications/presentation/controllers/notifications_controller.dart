import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/notifications/data/models/notification_data_model.dart';
import 'package:iroyal/app/modules/notifications/data/models/tap_notification_data_model.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_data_list_entities.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_dummy.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/notification_entities.dart';
import 'package:iroyal/app/modules/notifications/domain/entities/tap_notification_entities.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/get_notifications.dart';
import 'package:iroyal/app/modules/notifications/domain/usecases/tap_notification.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/errors/exception.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class NotificationsController extends GetxController {
  NotificationsController(
      {required this.getNotifications, required this.tapNotification});

  var filterNewNotif = <NotificationsDummy>[].obs;
  var notifDummy = <NotificationsDummy>[].obs;

  RxBool isLoading = false.obs;
  RxBool isLoadMore = false.obs;
  RxBool hasMoreData = true.obs;

  RxInt currentPage = 1.obs;
  RxInt totalPages = 1.obs;

  final Rx<NotificationEntities> notificationsData = const NotificationEntities(
          code: 0,
          message: '',
          data: NotificationDataModel(currentPage: 0, data: [], totalPage: 0))
      .obs;

  final RxList<NotificationDataListEntities> notificationsDataList =
      <NotificationDataListEntities>[].obs;

  final Rx<TapNotificationEntities> tapNotificationData =
      const TapNotificationEntities(
              0, '', TapNotificationDataModel(0, '', 'route'))
          .obs;

  final GetNotifications getNotifications;
  final TapNotification tapNotification;
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() async {
    await _getNotifications();
    notificationsDataList.value = notificationsData()
        .data
        .data
        .map((e) => NotificationDataListEntities(
            id: e.id,
            createdAt: e.createdAt,
            body: e.body,
            title: e.title,
            isRead: e.isRead))
        .toList();
    scrollController.addListener(_scrollListener);

    AppUtils.logApp(
        'NOTIF DATA ::: ${notificationsData.value.data.data.length}');
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> _getNotifications() async {
    isLoading.value = true;

    final result = await getNotifications(currentPage.value);

    result.fold(
      (l) {
        isLoading.value = false;
        final m = l.properties[0] as ApiException;
        AppDialogImpl().showErrorDialog(description: m.message);
      },
      (r) {
        isLoading.value = false;
        notificationsData.value = r;
        notificationsDataList.addAll(notificationsData()
            .data
            .data
            .map((e) => NotificationDataListEntities(
                id: e.id,
                createdAt: e.createdAt,
                body: e.body,
                title: e.title,
                isRead: e.isRead))
            .toList());

        totalPages.value = notificationsData().data.totalPage;

        if (currentPage.value >= totalPages.value) {
          hasMoreData.value = false;
        }
      },
    );
  }

  Future<void> _getMoreNotifications() async {
    isLoadMore.value = true;

    final result = await getNotifications(currentPage.value);

    result.fold(
      (l) {
        isLoadMore.value = false;
      },
      (r) {
        isLoadMore.value = false;
        notificationsData.value = r;
        notificationsDataList.addAll(notificationsData()
            .data
            .data
            .map((e) => NotificationDataListEntities(
                  id: e.id,
                  createdAt: e.createdAt,
                  body: e.body,
                  title: e.title,
                  isRead: e.isRead,
                ))
            .toList());

        totalPages.value = notificationsData().data.totalPage;

        if (currentPage.value >= totalPages.value) {
          hasMoreData.value = false;
        }
      },
    );
  }

  void _scrollListener() {
    AppUtils.logApp('scroll');
    if (scrollController.position.pixels ==
            scrollController.position.maxScrollExtent &&
        hasMoreData.value) {
      loadMoreNotifications();
    }
  }

  void loadMoreNotifications() {
    AppUtils.logApp('load more');
    if (!isLoading.value && !isLoadMore.value && hasMoreData.value) {
      isLoadMore.value = true;
      currentPage.value++;
      _getMoreNotifications();
    }
  }

  void onTapNotification(int notificationId) async {
    isLoading.value = true;

    final result = await tapNotification(notificationId);

    result.fold(
      (l) {
        AppUtils.logApp('Error');
      },
      (r) {
        isLoading.value = false;
        AppUtils.logApp('Success');
        _getNotifications();
        tapNotificationData.value = r;
        switch (tapNotificationData.value.data.route) {
          case 'My Teams':
            Get.toNamed(Routes.MY_TEAMS);
            break;
          case 'Webtel':
            Get.offAndToNamed(Routes.WEBTEL);
            break;
          case 'Tracking Documents':
            Get.offAndToNamed(Routes.TRACKING_DOCUMENT);
            break;
          case 'Leave Summary':
            Get.offAndToNamed(Routes.LEAVE_SUMMARY);
            break;
          case 'Tasks':
            Get.offAndToNamed(Routes.TASKS);
            break;
          case 'Payroll':
            Get.offAndToNamed(Routes.PIN);
            break;
          case 'Dashboard':
            Get.offAndToNamed(Routes.DASHBOARD);
            break;
          case 'Visit':
            Get.offAndToNamed(Routes.VISIT);
            break;
          case 'Bottom Navbar':
            Get.offAllNamed(Routes.BOTTOMNAVBAR);
            break;
          default:
            null;
            break;
        }
      },
    );
  }
}
