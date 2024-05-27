import 'dart:async';

import 'package:get/get.dart';

class AttendanceController extends GetxController {
  final currentTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  RxBool isCheckIn = false.obs;
  RxBool isCheckOut = false.obs;

  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        currentTime.value = DateTime.now();
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  void checkIn() {
    isCheckIn.value = true;
  }

  void checkOut() {
    isCheckOut.value = true;
    checkOutTime.value = DateTime.now();
    _timer.cancel();
  }
}
