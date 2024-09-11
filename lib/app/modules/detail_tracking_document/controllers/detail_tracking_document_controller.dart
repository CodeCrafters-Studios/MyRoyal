import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
}
