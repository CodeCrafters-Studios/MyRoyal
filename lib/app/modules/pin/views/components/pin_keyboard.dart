import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:MyRoyal/app/modules/pin/controllers/pin_controller.dart';
import 'package:MyRoyal/base/design/styles.dart';
import 'package:MyRoyal/base/widgets/card/card_app.dart';
import 'package:MyRoyal/base/widgets/inkwell_tap.dart';

class PinKeyboard extends StatelessWidget {
  const PinKeyboard({super.key, required this.controller});
  final PinController controller;

  @override
  Widget build(BuildContext context) {
    return CardApp(
      isShadow: true,
      shadows: Shadows.universal,
      child: GridView.count(
        crossAxisCount: 3,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 20 / 11,
        padding: const EdgeInsets.only(top: 8),
        children: controller.keyboards.map((e) {
          if (e == 'back') {
            return ItemKeyboardSymbol(text: e, onTap: controller.onKeyDelete);
          } else {
            return ItemKeyboard(text: e, onTap: () => controller.setPin(e));
          }
        }).toList(),
      ),
    );
  }
}

class ItemKeyboard extends StatelessWidget {
  const ItemKeyboard({super.key, required this.text, required this.onTap});
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) {
      return const SizedBox();
    } else {
      return CardApp(
        isShadow: true,
        margin: REdgeInsets.all(8),
        shadows: Shadows.small,
        child: InkWellTap(
          radius: 10,
          onTap: onTap,
          child: Center(
            child: Text(
              text,
              style: TS.bodyLarge.copyWith(fontSize: 24.sp),
            ),
          ),
        ),
      );
    }
  }
}

class ItemKeyboardSymbol extends StatelessWidget {
  const ItemKeyboardSymbol({
    super.key,
    required this.text,
    required this.onTap,
  });
  final String text;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: REdgeInsets.all(8),
      child: InkWellTap(
        radius: 10,
        onTap: onTap,
        child: const Icon(Icons.backspace_outlined),
      ),
    );
  }
}
