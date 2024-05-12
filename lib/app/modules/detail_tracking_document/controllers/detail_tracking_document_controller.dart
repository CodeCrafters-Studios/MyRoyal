import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/status_approval_entities.dart';
import 'package:iroyal/base/design/colors.dart';

class DetailTrackingDocumentController extends GetxController with StateMixin {
  late final TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: _TickerProvider());
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  final List<StatusApprovalEntity> statusApproval = <StatusApprovalEntity>[
    StatusApprovalEntity(
      borderColor: primary50,
      decorationColor: primary50,
      icon: '!',
      iconColor: primary50,
      isIcon: false,
      status: 'OVERDUE',
      statusColor: primary50,
    ),
    StatusApprovalEntity(
      borderColor: secondary,
      decorationColor: secondary,
      icon: '',
      iconColor: secondary,
      isIcon: true,
      status: 'URGENT',
      statusColor: secondary,
    ),
  ];
}

class _TickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
