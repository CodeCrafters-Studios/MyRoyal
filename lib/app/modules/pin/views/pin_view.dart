import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:iroyal/app/modules/pin/views/components/pin_keyboard.dart';
import 'package:iroyal/app/modules/pin/views/components/pin_text_view.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/page_base.dart';

import '../controllers/pin_controller.dart';

class PinView extends GetView<PinController> {
  const PinView({super.key});
  @override
  Widget build(BuildContext context) {
    return PageBase(
      showBackground: false,
      useTopPadding: true,
      title: 'PIN',
      child: Column(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Enter PIN', style: TS.labelLarge),
                16.verticalSpace,
                Obx(
                  () => PinTextView(
                    pin: controller.pin(),
                    controller: controller,
                  ),
                ),
                48.verticalSpace,
                TextButton(
                  onPressed: controller.forgotPin,
                  child: const Text(
                    'Forgot PIN?',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 5,
            child: PinKeyboard(
              controller: controller,
            ),
          ),
        ],
      ),
    );
  }
}
