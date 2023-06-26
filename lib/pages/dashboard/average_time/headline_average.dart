import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../configs/constants.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';

class AverageTime extends StatefulWidget {
  const AverageTime({Key? key}) : super(key: key);

  @override
  State<AverageTime> createState() => _AverageTimeState();
}

class _AverageTimeState extends State<AverageTime> {
  late final Future<List<StatsModel>> _statsFuture;

  @override
  void initState() {
    _statsFuture = DatabaseServiceAppData().getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _statsFuture,
      builder: (context, snapshot) {
        List<StatsModel> stats = [];
        String averageTime = '0 mins';

        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          stats.addAll(snapshot.data!);

          final totalTime = stats.fold(
              0,
              (previousValue, element) =>
                  previousValue + element.totalMeditationTime);

          averageTime =
              ((totalTime ~/ stats.length)).formatFromMilliseconds().toString();
        }

        return Center(
          child: FadeInAnimation(
            delayMilliseconds: kFadeInDelayMilliseconds,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'You meditate on average for ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: averageTime,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: stats.isNotEmpty
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
