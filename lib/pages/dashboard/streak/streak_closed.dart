import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../app_components/custom_circular_progress.dart';
import '../../../configs/constants.dart';
import '../../../enums/time_period.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';
import '../../../utils/methods/stats_methods.dart';
import '../stats_components/more_arrow.dart';

class StreakClosed extends StatefulWidget {
  const StreakClosed({
    super.key,
  });

  @override
  State<StreakClosed> createState() => _StreakClosedState();
}

class _StreakClosedState extends State<StreakClosed> {
  late final Future _allGroupedFuture;

  @override
  void initState() {
    _allGroupedFuture = DatabaseServiceAppData().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusBig)),
      child: FutureBuilder(
        future: _allGroupedFuture,
        builder: (context, snapshot) {
          List<StatsModel> stats = [];
          String currentStreakString = '0';
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          }
          if (snapshot.hasData) {
            if (snapshot.data!.isNotEmpty) {
              stats = snapshot.data!;
              currentStreakString = getCurrentStreak(stats).toString();
            }
          }
          return Column(
            children: [
              const Expanded(
                flex: 2,
                child: Icon(
                  FontAwesomeIcons.award,
                  size: kDashboardIconSize,
                ),
              ),
              Expanded(
                flex: 2,
                child: FadeInAnimation(
                  delayMilliseconds: kFadeInDelay,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: 'Current streak ',
                      style: Theme.of(context).textTheme.bodyLarge,
                      children: [
                        TextSpan(
                          text: ' $currentStreakString',
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: stats.isNotEmpty
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(context)
                                          .colorScheme
                                          .surfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(child: MoreArrow()),
            ],
          );
        },
      ),
    );
  }
}
