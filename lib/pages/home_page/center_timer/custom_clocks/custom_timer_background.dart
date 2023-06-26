import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../configs/constants.dart';
import '../../../../enums/clock_design.dart';

class CustomTimerBackground extends CustomPainter {
  final Color clockBackground;
  final Color? clockLongTick;
  final TimerDesign timerDesign;

  CustomTimerBackground({
    required this.timerDesign,
    required this.clockBackground,
    this.clockLongTick,
  });

  @override

  /// CIRCLE
  void paint(Canvas canvas, Size size) {
    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * kTimerRadius, centerY * kTimerRadius);
    final strokeWidth = size.width * kStrokeWidth * 0.90;

    Paint paint = Paint()
      ..color = clockBackground
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    if (timerDesign == TimerDesign.circle) {
      final path = Path()
        ..addArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2,
            math.pi * 2);

      canvas.drawPath(path, paint);
    } else if (timerDesign == TimerDesign.dots) {
      /// DOTS
      Paint paint = Paint()..color = clockBackground;

      double radius = math.min(centerX * kTimerRadius, centerY * kTimerRadius);

      paint.style = PaintingStyle.fill;

      for (double i = -90; i < 360; i += kNumberOfCirclesMultiplier) {
        var x1 = center.dx + radius * math.cos(i * math.pi / 180);
        var y1 = center.dy + radius * math.sin(i * math.pi / 180);
        canvas.drawCircle(Offset(x1, y1), size.width * kDotSize, paint);
      }
    } else if (timerDesign == TimerDesign.dash) {
      /// DASH
      double radius = math.min(centerX * kTimerRadius * kDashRadiusMultiplier,
          centerY * kTimerRadius);
      double dashBuffer = size.width * kDashBuffer;
      final strokeWidth = size.width * kDashWidth;
      paint
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      for (double i = -90; i < 360; i += kDashTimerNumberOfDashesMultiplier) {
        var x1 =
            center.dx + (radius + dashBuffer) * math.cos(i * math.pi / 180);
        var y1 =
            center.dy + (radius + dashBuffer) * math.sin(i * math.pi / 180);

        var x2 = center.dx +
            (radius + dashBuffer * kDashBufferMultiplier) *
                math.cos(i * math.pi / 180);
        var y2 = center.dy +
            (radius + dashBuffer * kDashBufferMultiplier) *
                math.sin(i * math.pi / 180);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);
      }
    } else if (timerDesign == TimerDesign.clock) {
      /// CLOCK - SHADOW
      double radius = math.min(centerX * kTimerRadius, centerY * kTimerRadius);

      var circlePaint = Paint()
        ..color = clockBackground
        ..strokeWidth = radius * kStrokeWidth;

      final circlePath = Path()
        ..addArc(
            Rect.fromCircle(
                center: center, radius: radius * kClockTimerRadiusMultiplier),
            -math.pi / 2,
            math.pi * 2);

      canvas.drawPath(circlePath, circlePaint);

      /// CLOCK - MARKERS

      var dashBrushSmall = Paint()
        ..style = PaintingStyle.fill
        ..strokeCap = StrokeCap.round
        ..strokeWidth = size.width * 0.025;

      double dotBuffer = 1;
      int dotBufferMultiplier = 2;

      for (double i = -90; i < 360; i += 6) {
        dashBrushSmall.color = Colors.transparent;
        dotBuffer = size.width * 0.001;
        if (i % 30 == 0) {
          dashBrushSmall.color = clockLongTick!;
          dotBuffer = size.width * 0.002;
        }
        var x1 = center.dx + (radius * 0.90) * math.cos(i * math.pi / 180);
        var y1 = center.dy + (radius * 0.90) * math.sin(i * math.pi / 180);

        var x2 = center.dx +
            ((radius * 0.95) + dotBuffer * dotBufferMultiplier) *
                math.cos(i * math.pi / 180);
        var y2 = center.dy +
            ((radius * 0.95) + dotBuffer * dotBufferMultiplier) *
                math.sin(i * math.pi / 180);

        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), dashBrushSmall);
      }
    } else if (timerDesign == TimerDesign.semi) {
      /// SEMI

      final path = Path()
        ..addArc(
            Rect.fromCircle(center: center, radius: radius), -math.pi, math.pi);

      canvas.drawPath(path, paint);
    } else if (timerDesign == TimerDesign.line) {
      /// LINE
      paint.strokeCap = StrokeCap.round;

      final path = Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0);

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
