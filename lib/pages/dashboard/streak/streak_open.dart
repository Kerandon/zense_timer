import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import '../../../animation/confetti_animation.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../app_components/custom_circular_progress.dart';
import '../../../configs/constants.dart';
import '../../../enums/time_period.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';
import '../../../utils/methods/stats_methods.dart';
import '../stats_components/headline_tile.dart';

class StreakOpen extends StatefulWidget {
  const StreakOpen({
    Key? key,
  }) : super(key: key);

  @override
  State<StreakOpen> createState() => _StreakOpenState();
}

class _StreakOpenState extends State<StreakOpen> {
  late final Future<List<StatsModel>> _allGroupedFuture;

  @override
  void initState() {
    _allGroupedFuture = DatabaseServiceAppData().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder<List<StatsModel>>(
      future: _allGroupedFuture,
      builder: (context, snapshot) {
        List<StatsModel> stats = [];
        int currentStreak = 0;
        int bestStreak = 0;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CustomLoadingIndicator();
        }
        bool hasData = false;
        if (snapshot.hasData) {
          if (snapshot.data!.isNotEmpty) {
            stats = snapshot.data!;
            currentStreak = getCurrentStreak(stats);
            bestStreak = getBestStreak(stats);
            hasData = true;
          }
        }

        String bestStreakResultText = '0';
        if (currentStreak > 0 && currentStreak >= bestStreak) {
          bestStreakResultText = 'Current';
        } else {
          bestStreakResultText = bestStreak.toString();
        }

        String encouragementMsg = "";
        if (currentStreak > 0 && currentStreak < 3) {
          encouragementMsg = kStreakEncouragementMsg1;
        } else if (currentStreak >= 3 && currentStreak < 6) {
          encouragementMsg = kStreakEncouragementMsg2;
        } else if (currentStreak >= 6 && currentStreak < 10) {
          encouragementMsg = kStreakEncouragementMsg3;
        } else if (currentStreak >= 10 && currentStreak < 15) {
          encouragementMsg = kStreakEncouragementMsg4;
        } else if (currentStreak >= 15 && currentStreak < 20) {
          encouragementMsg = kStreakEncouragementMsg5;
        } else if (currentStreak >= 20) {
          encouragementMsg = kStreakEncouragementMsg6;
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Daily Streak'),
          ),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(size.width * 0.05),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.all(size.width * kPageIndentation * 2),
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(minHeight: size.height * 0.25),
                          child: Center(
                            child: Shimmer.fromColors(
                                baseColor: hasData
                                    ? Theme.of(context).colorScheme.primary
                                    : Colors.grey,
                                highlightColor: hasData
                                    ? Theme.of(context).colorScheme.secondary
                                    : Colors.grey,
                                delay: const Duration(seconds: 6),
                                child: const Icon(
                                  FontAwesomeIcons.award,
                                  size: 150,
                                )),
                          ),
                        ),
                      ),
                      FadeInAnimation(
                        delayMilliseconds: kFadeInDelayMilliseconds,
                        child: Shimmer.fromColors(
                          baseColor: hasData ? Colors.amber : Colors.grey,
                          highlightColor: hasData ? Colors.yellow : Colors.grey,
                          delay: const Duration(seconds: 2),
                          child: Text(
                            currentStreak.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .displayLarge!
                                .copyWith(
                                  fontSize: 200,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                          ),
                        ),
                      ),
                      Text(
                        encouragementMsg,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: size.height * 0.10),
                        child: SizedBox(
                          child: HeadlineTile(
                            removeBackgroundColor: true,
                            content: FadeInAnimation(
                              delayMilliseconds: kFadeInDelayMilliseconds,
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  text: 'Best Streak ',
                                  style: Theme.of(context).textTheme.bodyLarge,
                                  children: [
                                    TextSpan(
                                        text: bestStreakResultText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                                color: hasData
                                                    ? Theme.of(context)
                                                        .colorScheme
                                                        .primary
                                                    : Theme.of(context)
                                                        .colorScheme
                                                        .surfaceVariant,
                                                fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              ConfettiAnimation(
                animate: currentStreak > 0,
              ),
            ],
          ),
        );
      },
    );
  }
}
