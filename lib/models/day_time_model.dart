import 'package:zense_timer/enums/day_time.dart';
import 'package:flutter/material.dart';

class DayTimeModel {
  final DayTime time;
  final double percent;
  final Color color;

  DayTimeModel(
      {required this.time, required this.percent, required this.color});
}
