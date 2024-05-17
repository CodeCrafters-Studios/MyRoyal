import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({
    this.bgColor,
    this.fgColor,
    super.key,
  });

  final Color? bgColor;
  final Color? fgColor;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCircle(
        size: 24,
        itemBuilder: (BuildContext context, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: fgColor ?? Colors.white,
            ),
          );
        },
      ),
    );
  }
}
