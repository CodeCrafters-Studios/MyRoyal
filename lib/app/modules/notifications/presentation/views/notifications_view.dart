import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:MyRoyal/app/modules/home/presentation/views/components/shimmer_text.dart';

import 'package:MyRoyal/app/modules/notifications/presentation/views/components/no_notifications_view.dart';
import 'package:MyRoyal/app/modules/notifications/presentation/views/components/notifications_card.dart';
import 'package:MyRoyal/base/config/app_config.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/widgets/appbar_spacer.dart';
import 'package:MyRoyal/base/widgets/padding.dart';
import 'package:MyRoyal/base/widgets/page_base.dart';

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
        () => controller.isLoading.value &&
                controller.notificationsDataList.isEmpty
            ? _buildLoadingNotificationsList(context)
            : controller.notificationsDataList.isEmpty
                ? const NoNotificationsView()
                : Column(
                    children: [
                      AppbarSpacer(
                        height: AppConfig.iAppBarHeight +
                            MediaQuery.of(context).viewPadding.top,
                      ),
                      Expanded(
                        child: _buildNotificationsList(),
                      ),
                    ],
                  ),
      ),
    );
  }

  Widget _buildLoadingNotificationsList(BuildContext context) {
    return Column(
      children: [
        AppbarSpacer(
          height:
              AppConfig.iAppBarHeight + MediaQuery.of(context).viewPadding.top,
        ),
        Expanded(
          child: ListView.builder(
            controller: controller.scrollController,
            padding: REdgeInsets.only(bottom: 100),
            itemCount: 10,
            itemBuilder: (_, index) {
              return ListTile(
                title: EPadding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: ShimmerText(
                    height: 15.h,
                    width: 150.w,
                  ),
                ),
                subtitle: ShimmerText(
                  height: 15.h,
                  width: 150.w,
                ),
                isThreeLine: true,
                trailing: ShimmerText(
                  height: 15.h,
                  width: 60.w,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationsList() {
    return RefreshIndicator(
      backgroundColor: white,
      color: primary,
      onRefresh: controller.onRefresh,
      child: RepaintBoundary(
        child: ListView.builder(
          controller: controller.scrollController,
          padding: REdgeInsets.only(bottom: 100),
          itemCount: controller.notificationsDataList.length +
              (controller.isLoadMore.value ? 1 : 0),
          itemBuilder: (_, index) {
            if (controller.isLoadMore.value &&
                index == controller.notificationsDataList.length) {
              return const Center(
                  child: CircularProgressIndicator(color: primary));
            }
            final notification = controller.notificationsDataList[index];
            final scheduledDate = notification.createdAt
                    .isBefore(DateTime.now().subtract(Duration(days: 1)))
                ? (notification.createdAt
                        .isBefore(DateTime.now().subtract(Duration(days: 2)))
                    ? DateFormat('dd MMM yyyy').format(notification.createdAt)
                    : 'yesterday')
                : DateFormat('hh:mm a').format(notification.createdAt);

            return NotificationsCard(
              title: notification.title,
              description: notification.body,
              date: scheduledDate,
              isRead: notification.isRead,
              onTap: () => controller.onTapNotification(notification.id),
            );
          },
        ),
      ),
    );
  }
}
