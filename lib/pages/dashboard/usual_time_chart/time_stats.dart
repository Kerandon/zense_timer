import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../enums/day_time.dart';
import '../../../models/day_time_model.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';
import 'legend_key.dart';
import 'linear_chart.dart';

class TimeStats extends ConsumerStatefulWidget {
  const TimeStats({
    super.key,
  });

  @override
  ConsumerState<TimeStats> createState() => _TimeStatsState();
}

class _TimeStatsState extends ConsumerState<TimeStats> {
  late final Future<List<StatsModel>> _statsFuture;

  bool _animate = false;

  @override
  void initState() {
    _statsFuture = DatabaseServiceAppData().getAllStats();
    Future.delayed(const Duration(milliseconds: kFadeInDelayMilliseconds * 2),
        () {
      _animate = true;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<StatsModel>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        List<Color> colors = [
          const Color(0xffE7C582),
          const Color(0xff00A5E3),
          const Color(0xff8DD7bF),
          const Color(0xffE77577),
        ];

        List<DateTime> dateTimeStats = [];

        Map<DayTime, int> dayTimesTotals = {
          DayTime.morning: 0,
          DayTime.afternoon: 0,
          DayTime.evening: 0,
          DayTime.lateNight: 0
        };
        List<DayTimeModel> dayTimes = [];

        /// Morning 3-11.59; 180M to 719M
        /// Afternoon 12-17.59; 720M to 1079M
        /// Evening 18-20.59; 1080M to 1259M
        /// Late night 21-2.59; 1260M to 179M

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          for (var s in snapshot.data!) {
            dateTimeStats.add(s.dateTime);
          }

          for (var d in dateTimeStats) {
            int timeInMinutes = (d.hour * 60) + d.minute;

            if (timeInMinutes >= 180 && timeInMinutes <= 719) {
              dayTimesTotals.update(DayTime.morning, (value) => value + 1);
            } else if (timeInMinutes >= 720 && timeInMinutes <= 1079) {
              dayTimesTotals.update(DayTime.afternoon, (value) => value + 1);
            } else if (timeInMinutes >= 1080 && timeInMinutes <= 1259) {
              dayTimesTotals.update(DayTime.evening, (value) => value + 1);
            } else {
              dayTimesTotals.update(DayTime.lateNight, (value) => value + 1);
            }
          }
        }
        final values = dayTimesTotals.values;
        final totalEntries =
            values.fold(0, (previousValue, element) => previousValue + element);

        for (int i = 0; i < DayTime.values.length; i++) {
          final e = dayTimesTotals.entries;
          dayTimes.add(
            DayTimeModel(
                time: e.elementAt(i).key,
                percent: snapshot.hasData && snapshot.data!.isNotEmpty
                    ? e.elementAt(i).value / totalEntries
                    : 0,
                color: colors[i]),
          );
        }

        final size = MediaQuery.of(context).size;

        return Center(
          child: Padding(
            padding:
                EdgeInsets.symmetric(vertical: size.height * kPageIndentation),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Your usual meditation time',
                  style: Theme.of(context).textTheme.bodyLarge!,
                  textAlign: TextAlign.center,
                ).animate().fadeIn(),
                FadeInAnimation(
                  delayMilliseconds: kFadeInDelayMilliseconds,
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: size.height * kPageIndentation),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: List.generate(
                        dayTimes.length,
                        (index) => LegendKey(
                          text: dayTimes[index].time.toText(),
                          color: dayTimes[index].color,
                          percent: dayTimes[index].percent,
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: size.height * 0.01),
                  child: AnimatedContainer(
                      width: _animate ? size.width * 0.90 : 0,
                      duration: const Duration(milliseconds: 1600),
                      curve: Curves.easeOutCubic,
                      child: LinearChart(
                        dayTimes: dayTimes,
                      )),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
