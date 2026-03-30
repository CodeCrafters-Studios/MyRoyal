import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:MyRoyal/app/modules/pin/controllers/pin_controller.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';

class PinTextView extends StatelessWidget {
  const PinTextView({
    super.key,
    required this.pin,
    required this.controller,
  });
  final String pin;
  final PinController controller;

  @override
  Widget build(BuildContext context) {
    final lengthNotDot = 6 - pin.length;
    final safeLengthNotDot = lengthNotDot < 0 ? 0 : lengthNotDot;
    final emptyCards = List<Widget>.generate(
        safeLengthNotDot,
        (index) => PinHolder(
              controller: controller,
            ));
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ...pin.split('').map(
              (e) => PinHolder(
                controller: controller,
                isShowDot: true,
              ),
            ),
        ...emptyCards,
      ],
    );
  }
}

class PinHolder extends StatelessWidget {
  const PinHolder({
    super.key,
    this.isShowDot = false,
    required this.controller,
  });
  final bool isShowDot;
  final PinController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CardApp(
        outlineColor: controller.outlineColor.value,
        isOutlined: true,
        borderWidth: 1,
        margin: REdgeInsets.symmetric(horizontal: 4),
        width: 44.w,
        height: 44.w,
        child: isShowDot
            ? Center(
                child: Text(
                  '●',
                  style: TS.titleMedium,
                ),
              )
            : const SizedBox(),
      ),
    );
  }
}
