import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iroyal/app/modules/tracking_document/domain/entities/status_approval_entities.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/widgets/others/ticker_provider.dart';

class DetailTrackingDocumentController extends GetxController {
  late final TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 4, vsync: TicckerProvider());
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
      icon: '',
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
