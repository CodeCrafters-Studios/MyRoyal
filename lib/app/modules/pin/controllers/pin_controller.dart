import 'dart:ui';

import 'package:get/get.dart';
import 'package:iroyal/app/routes/app_pages.dart';
import 'package:iroyal/base/design/colors.dart';

class PinController extends GetxController {
  var pin = ''.obs;
  var outlineColor = Rx<Color>(grey);

  void setPin(String value) {
    if (pin.value.length < 6) {
      outlineColor.value = grey;
      pin.value += value;
    }
    // Check if the pin is '000000'
    if (pin.value == '000000' && pin.value.length == 6) {
      outlineColor.value = grey;
      Get.offNamed(Routes.PAYROLL);
    } else if (pin.value.length == 6) {
      pin.value = '';
      outlineColor.value = red;
    }
  }

  void onKeyDelete() {
    if (pin.value.isNotEmpty) {
      pin.value = pin.value.substring(0, pin.value.length - 1);
    }
  }

  void forgotPin() {
    // Handle forgot pin logic
  }

  List<String> get keyboards =>
      ['1', '2', '3', '4', '5', '6', '7', '8', '9', '', '0', 'back'];
}
