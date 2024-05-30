// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class AppPopScope extends StatelessWidget {
  const AppPopScope({super.key, required this.child, this.onBack});
  final Widget child;
  final Function()? onBack;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: child,
      onWillPop: () async {
        if (onBack != null) {
          onBack!.call();
        }
        return false;
      },
    );
  }
}
