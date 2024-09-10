import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:iroyal/app/modules/notifications/presentation/views/components/no_notifications_view.dart';
import 'package:iroyal/app/modules/notifications/presentation/views/components/notifications_card.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return NotificationsViewImpl(controller: controller);
  }
}

class NotificationsViewImpl extends StatelessWidget {
  const NotificationsViewImpl({super.key, required this.controller});

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Notifications',
      child: Obx(
        () => controller.notificationsDataList.isEmpty
            ? const NoNotificationsView()
            : controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: primary,
                    ),
                  )
                : Column(
                    children: [
                      const AppbarSpacer(),
                      Expanded(
                        child: _buildNotificationsList(),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.builder(
      controller: controller.scrollController,
      padding: REdgeInsets.only(bottom: 100),
      itemCount: controller.notificationsDataList.length +
          (controller.isLoadMore.value ? 1 : 0),
      itemBuilder: (_, index) {
        if (controller.isLoadMore.value &&
            index == controller.notificationsDataList.length) {
          return const Center(child: CircularProgressIndicator());
        }
        final notification = controller.notificationsDataList[index];
        return NotificationsCard(
          title: notification.title,
          description: notification.body,
          date: DateFormat('hh:mm a').format(notification.createdAt),
          isRead: notification.isRead,
          onTap: () => controller.onTapNotification(notification.id),
        );
      },
    );
  }
}
