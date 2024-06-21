import 'package:get/get.dart';

class ChangePinController extends GetxController {
  RxString newPin = ''.obs;
  RxString confirmPin = ''.obs;

  void setNewPin(String value) {
    newPin.value = value;
  }

  void setConfirmPin(String value) {
    confirmPin.value = value;
  }
}
