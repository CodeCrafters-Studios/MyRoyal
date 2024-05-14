import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';

class TasksController extends GetxController with StateMixin {
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
}

class _TickerProvider extends TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
