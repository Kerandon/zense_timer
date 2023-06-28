import 'dart:math' as math;
import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';

class CustomTimerDash extends CustomPainter {
  final double percentage;

  CustomTimerDash({
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var adjustedPercent = (360 * percentage) - (90 - 3.6);

    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(
        centerX * kTimerRadius * kDashRadiusMultiplier, centerY * kTimerRadius);
    double dashBuffer = size.width * kDashBuffer;
    final strokeWidth = (size.width * kDashWidth);

    var dashBrush = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    for (double i = -90;
        i < adjustedPercent;
        i += kDashTimerNumberOfDashesMultiplier) {
      var x1 = center.dx + (radius + dashBuffer) * math.cos(i * math.pi / 180);
      var y1 = center.dy + (radius + dashBuffer) * math.sin(i * math.pi / 180);

      var x2 = center.dx +
          (radius + dashBuffer * kDashBufferMultiplier) *
              math.cos(i * math.pi / 180);
      var y2 = center.dy +
          (radius + dashBuffer * kDashBufferMultiplier) *
              math.sin(i * math.pi / 180);

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrush);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
