import 'package:flutter/material.dart';
import 'package:iroyal/base/design/colors.dart';
import 'package:iroyal/base/design/styles.dart';
import 'package:iroyal/base/widgets/others/log_button.dart';

class OverlayLogButton extends StatefulWidget {
  const OverlayLogButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  OverlayLogButtonState createState() => OverlayLogButtonState();
}

class OverlayLogButtonState extends State<OverlayLogButton> {
  double _y = 100;
  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => Positioned(
            right: 0,
            top: _y,
            child: SizedBox(
              height: IconSizes.xl,
              width: IconSizes.xl,
              child: Draggable(
                feedback: LogButton(color: Colors.green, onTap: widget.onTap),
                childWhenDragging: Container(),
                onDragEnd: (dragDetails) {
                  setState(() {
                    _y = dragDetails.offset.dy - 20;
                  });
                },
                child: LogButton(
                  color: primaryColor.withOpacity(.1),
                  onTap: widget.onTap,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
