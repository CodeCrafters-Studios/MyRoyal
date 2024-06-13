import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:iroyal/base/utils/app_utils.dart';
import 'package:iroyal/base/utils/dialog/app_dialog.dart';

class AttendanceController extends GetxController {
  final currentTime = DateTime.now().obs;
  final checkInTime = DateTime.now().obs;
  final checkOutTime = DateTime.now().obs;
  final breakTime = DateTime.now().obs;
  late GoogleMapController mapController;
  final Completer<GoogleMapController> controller = Completer();
  final currentPosition = Rxn<LatLng>();
  final locationError = RxnString();

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
    getCurrentLocation();
  }

  @override
  void onClose() {
    super.onClose();
    _timer.cancel();
  }

  Future<void> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 15),
      );
      currentPosition.value = LatLng(position.latitude, position.longitude);
    } catch (e) {
      // Handle any other errors.
      locationError.value = "Failed to get location: ${e.toString()}";
    }
  }

  void onMapCreated(GoogleMapController controller) {
    if (!this.controller.isCompleted) {
      mapController = controller;
      this.controller.complete(controller);
    }
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

  void checkOut() {
    AppDialogImpl().showChoiceDialog(
      title: 'Confirmation',
      description: 'Are you sure want to Checkout?',
      onPressedYes: () {
        Get.back();
        isCheckOut.value = true;
        checkOutTime.value = DateTime.now();
        _timer.cancel();
        _totalHours();
      },
    );
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
