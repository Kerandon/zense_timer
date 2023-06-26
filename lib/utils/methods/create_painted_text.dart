import 'package:flutter/material.dart';
import 'dart:ui' as ui;

void createPaintedText(
  String? text, {
  required Canvas canvas,
  required Offset offset,
  double? minWidth,
  double? maxWidth,
  TextAlign textAlign = TextAlign.left,
  TextStyle? textStyle,
}) {
  TextSpan span = TextSpan(text: text, style: textStyle);
  TextPainter textPainter = TextPainter(
    text: span,
    textAlign: textAlign,
    ellipsis: '...', // this will add ... if the text overflows
    textDirection: ui.TextDirection.ltr,
  );
  textPainter.layout(minWidth: minWidth ?? 0.0, maxWidth: maxWidth ?? 0.0);

  textPainter.paint(
    canvas,
    offset,
  );
}
