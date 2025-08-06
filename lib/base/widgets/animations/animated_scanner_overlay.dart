import 'package:flutter/material.dart';

class AnimatedScannerOverlay extends StatefulWidget {
  const AnimatedScannerOverlay({super.key});

  @override
  State<AnimatedScannerOverlay> createState() => _AnimatedScannerOverlayState();
}

class _AnimatedScannerOverlayState extends State<AnimatedScannerOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        return AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return CustomPaint(
              painter: ScannerLinePainter(offset: _animation.value * height),
            );
          },
        );
      },
    );
  }
}

class ScannerLinePainter extends CustomPainter {
  final double offset;
  ScannerLinePainter({required this.offset});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red.withOpacity(0.7)
      ..strokeWidth = 2;

    canvas.drawLine(
      Offset(0, offset),
      Offset(size.width, offset),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
