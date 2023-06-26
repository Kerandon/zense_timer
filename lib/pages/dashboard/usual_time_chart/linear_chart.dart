import 'package:flutter/material.dart';

import '../../../models/day_time_model.dart';

class LinearChart extends StatelessWidget {
  const LinearChart({
    required this.dayTimes,
    super.key,
  });

  final List<DayTimeModel> dayTimes;

  @override
  Widget build(BuildContext context) {
    final isEmpty = dayTimes.every((element) => element.percent == 0);

    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width,
      height: size.height * 0.02,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.height * 0.10),
        child: isEmpty
            ? Container(
                color: Theme.of(context).secondaryHeaderColor,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  dayTimes.length,
                  (index) => Expanded(
                    flex: (dayTimes[index].percent * 100).toInt(),
                    child: Container(
                      color: dayTimes[index].color,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
