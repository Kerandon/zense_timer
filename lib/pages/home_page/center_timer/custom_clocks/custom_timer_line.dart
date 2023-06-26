import 'dart:ui' as ui;
import 'package:flutter/material.dart';

import '../../../../configs/constants.dart';

class CustomTimerLine extends CustomPainter {
  final double percentage;

  CustomTimerLine({
    required this.percentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black
      ..strokeWidth = kStrokeWidth * size.width;

    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0);

    ui.PathMetrics pathMetrics = path.computeMetrics();
    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted =
        pathMetric.extractPath(0.0, pathMetric.length * percentage);

    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
