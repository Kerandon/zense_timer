import 'package:zense_timer/animation/fade_in_animation.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/time_period.dart';
import '../../../models/stats_model.dart';
import '../../../state/chart_state.dart';
import '../../../state/database_service.dart';
import '../../../utils/methods/stats_methods.dart';

class HeadlineTotalTime extends ConsumerStatefulWidget {
  const HeadlineTotalTime({
    this.miniState = false,
    super.key,
  });

  final bool miniState;

  @override
  ConsumerState<HeadlineTotalTime> createState() =>
      _TotalMeditationTimeTitleState();
}

class _TotalMeditationTimeTitleState extends ConsumerState<HeadlineTotalTime> {
  TimePeriod currentPeriod = TimePeriod.week;

  @override
  Widget build(BuildContext context) {
    final chartState = ref.watch(chartStateProvider);
    String totalText = "0";
    String periodText = "";

    periodText = " in total";

    switch (chartState.barChartTimePeriod) {
      case TimePeriod.week:
        periodText = ' last week';
        break;
      case TimePeriod.fortnight:
        periodText = ' last fortnight';
        break;
      case TimePeriod.year:
        periodText = ' last year';
        break;
      case TimePeriod.allTime:
        ' in total';
        break;
    }

    if (widget.miniState) {
      periodText = ' last week';
    }

    return FutureBuilder(
      future: DatabaseServiceAppData().getStatsByTimePeriod(
          period: widget.miniState
              ? TimePeriod.week
              : chartState.barChartTimePeriod),
      builder: (context, snapshot) {
        List<StatsModel> statsData = [];
        totalText = '0 minutes';
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          statsData = snapshot.data!;
          totalText = calculateTotalMeditationTime(statsData, chartState);
        }

        return FadeInAnimation(
          resetBeforeAnimate: true,
          animateOnDemand: chartState.toggleBarChart,
          delayMilliseconds: kFadeInDelayMilliseconds,
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: !widget.miniState &&
                      chartState.barChartTimePeriod == TimePeriod.allTime
                  ? 'You have meditated for '
                  : 'You meditated for ',
              style: Theme.of(context).textTheme.bodyLarge,
              children: [
                TextSpan(
                  text: totalText,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: statsData.isNotEmpty
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.surfaceVariant),
                ),
                TextSpan(
                  text: periodText,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
