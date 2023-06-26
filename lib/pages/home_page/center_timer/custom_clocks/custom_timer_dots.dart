import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../configs/constants.dart';

class CustomTimerDots extends CustomPainter {
  final double percentage;

  CustomTimerDots({required this.percentage});

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);
    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * kTimerRadius, centerY * kTimerRadius);

    /// Circles

    final paint = Paint()..style = PaintingStyle.fill;

    for (double i = -90; i < adjustedPercent; i += kNumberOfCirclesMultiplier) {
      var x1 = center.dx + radius * math.cos(i * math.pi / 180);
      var y1 = center.dy + radius * math.sin(i * math.pi / 180);
      canvas.drawCircle(Offset(x1, y1), size.width * kDotSize, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
