import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/notifications/presentation/views/components/no_notifications_view.dart';
import 'package:iroyal/app/modules/notifications/presentation/views/components/notifications_card.dart';
import 'package:iroyal/base/widgets/appbar_spacer.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/notifications_controller.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});
  @override
  Widget build(BuildContext context) {
    return NotificationsViewImpl(
      controller: controller,
    );
  }
}

class NotificationsViewImpl extends StatelessWidget {
  const NotificationsViewImpl({
    super.key,
    required this.controller,
  });

  final NotificationsController controller;

  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      title: 'Notifications',
      child: controller.notifDummy.isEmpty
          ? const NoNotificationsView()
          : SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const AppbarSpacer(),
                  SizedBox(
                    height: Get.height,
                    child: Obx(
                      () => ListView.builder(
                        shrinkWrap: true,
                        padding: REdgeInsets.only(bottom: 100),
                        itemCount: controller.notifDummy.length,
                        itemBuilder: (_, index) {
                          final r = controller.notifDummy[index];
                          return NotificationsCard(
                            title: r.title,
                            description: r.description,
                            date: r.date,
                            isNew: r.isNew,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
