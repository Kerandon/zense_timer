import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class InfinityPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  InfinityPainter(
      {required this.progress, required this.color, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final minWidth = width * 0.05;
    final centerWidth = width * 0.50;
    final maxWidth = width * 0.95;

    final minHeight = height * 0.05;
    final centerHeight = height * 0.50;
    final maxHeight = height * 0.95;

    final path = Path()
      ..moveTo(minWidth, centerHeight)
      ..quadraticBezierTo(minWidth, minHeight, centerWidth, centerHeight)
      ..quadraticBezierTo(maxWidth, maxHeight, maxWidth, centerHeight)
      ..quadraticBezierTo(maxWidth, minHeight, centerWidth, centerHeight)
      ..quadraticBezierTo(minWidth, maxHeight, minWidth, centerHeight);

    ui.PathMetrics pathMetrics = path.computeMetrics();

    ui.PathMetric pathMetric = pathMetrics.elementAt(0);
    Path extracted = pathMetric.extractPath(0.0, pathMetric.length * progress);

    canvas.drawPath(extracted, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
