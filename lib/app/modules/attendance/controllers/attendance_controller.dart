import 'dart:async';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/base/utils/app_utils.dart';

class AttendanceController extends GetxController {
  final currentTime = DateTime.now().obs;
  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final breakTime = DateTime.now().obs;

  RxBool isCheckIn = false.obs;
  RxBool isCheckOut = false.obs;
  RxBool isBreakTime = false.obs;

  RxString totalHours = ''.obs;
  RxString countTimes = '--:--:--'.obs;

  late Timer _timer;

  Timer? countingTimer;
  Duration myDuration = const Duration();

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        currentTime.value = DateTime.now();
      },
    );
  }

  void checkIn() {
    isCheckIn.value = true;
    checkInTime.value = DateTime.now();
  }

  void checkOut() async {
    isCheckOut.value = true;
    checkOutTime.value = DateTime.now();
    _timer.cancel();
    _totalHours();
  }

  void _totalHours() {
    AppUtils.logApp(DateFormat('hh:mm a').format(checkInTime.value));
    AppUtils.logApp(DateFormat('hh:mm a').format(checkOutTime.value));

    Duration dif = checkOutTime.value.difference(checkInTime.value);

    AppUtils.logApp(dif.toString());
    AppUtils.logApp(dif.toString().substring(0, 4));

    String negativeSign = dif.isNegative ? '-' : '';
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(dif.inMinutes.remainder(60).abs());

    totalHours.value =
        "$negativeSign${twoDigits(dif.inHours)}h ${twoDigitMinutes}m";

    AppUtils.logApp(totalHours.value);
  }

  void startBreakTime() {
    isBreakTime.value = true;
    breakTime.value = DateTime.now();
    _startCountingTimer();
  }

  void _startCountingTimer() {
    countingTimer =
        Timer.periodic(const Duration(seconds: 1), (_) => setCountingTimer());
  }

  void endBreakTime() {
    countingTimer!.cancel();
    countTimes.value = '--:--:--';
    isBreakTime.value = false;
    myDuration = Duration.zero;

    AppUtils.logApp(countTimes.value);
    AppUtils.logApp('$myDuration');
  }

  void setCountingTimer() {
    const addSecondsBy = 1;
    final countSeconds = myDuration.inSeconds + addSecondsBy;
    myDuration = Duration(seconds: countSeconds);

    String twoDigits(int n) => n.toString().padLeft(2, "0");
    final hours = twoDigits(myDuration.inHours.remainder(24));
    final minutes = twoDigits(myDuration.inMinutes.remainder(60));
    final seconds = twoDigits(myDuration.inSeconds.remainder(60));

    countTimes.value = "$hours:$minutes:$seconds";

    AppUtils.logApp(countTimes.value);
  }
}
