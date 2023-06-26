import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../configs/constants.dart';

class CustomSemi extends CustomPainter {
  final double percentage;

  CustomSemi({
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double centerX = size.width;
    double centerY = size.height;
    Offset center = Offset(centerX / 2, centerY / 2);
    double radius = math.min(centerX * kTimerRadius, centerY * kTimerRadius);

    /// CIRCLE
    var circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = kStrokeWidth * size.width;

    final circlePath = Path()
      ..addArc(
          Rect.fromCircle(center: center, radius: radius), -math.pi, math.pi);

    ui.PathMetrics pathMetrics = circlePath.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted =
        pathMetric.extractPath(0.0, pathMetric.length * percentage);

    canvas.drawPath(extracted, circlePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
