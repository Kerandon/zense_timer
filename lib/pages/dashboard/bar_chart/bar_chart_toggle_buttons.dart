import 'package:flutter/material.dart';
import '../../../enums/time_period.dart';
import 'bar_chart_toggle.dart';

class BarChartToggleButtons extends StatelessWidget {
  const BarChartToggleButtons({
    required this.toggled,
    super.key,
    required this.disable,
  });

  final VoidCallback toggled;
  final bool disable;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        BarChartToggle(
          disable: disable,
          timePeriod: TimePeriod.week,
          toggledCallback: () => toggled.call(),
        ),
        BarChartToggle(
          disable: disable,
          timePeriod: TimePeriod.fortnight,
          toggledCallback: () => toggled.call(),
        ),
        BarChartToggle(
          disable: disable,
          timePeriod: TimePeriod.year,
          toggledCallback: () => toggled.call(),
        ),
        BarChartToggle(
          disable: disable,
          timePeriod: TimePeriod.allTime,
          toggledCallback: () => toggled.call(),
        ),
      ],
    );
  }
}
