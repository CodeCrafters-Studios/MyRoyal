import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:MyRoyal/base/design/colors.dart';
import 'package:MyRoyal/base/design/styles.dart';

class HaveNoAccount extends StatelessWidget {
  const HaveNoAccount({super.key, this.onTap});
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final stringArray = 'Dont have an Account? ^Click^ here'.split('^');
    return RichText(
      text: TextSpan(
        children: stringArray.mapIndexed(
          (index, element) {
            if (index.isEven) {
              return TextSpan(
                text: element,
                style: TS.bodySmall.copyWith(color: appTextColor),
              );
            } else {
              return TextSpan(
                text: element,
                style: TS.bodySmall.copyWith(color: primaryColor),
                recognizer: TapGestureRecognizer()..onTap = onTap,
              );
            }
          },
        ).toList(),
      ),
    );
  }
}
