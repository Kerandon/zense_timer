import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../app_components/custom_circular_progress.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';

class HeadlineLastMeditation extends ConsumerStatefulWidget {
  const HeadlineLastMeditation({
    super.key,
  });

  @override
  ConsumerState<HeadlineLastMeditation> createState() =>
      _LastMeditationTimeTitleState();
}

class _LastMeditationTimeTitleState
    extends ConsumerState<HeadlineLastMeditation> {
  late final Future<StatsModel> _lastEntryFuture;

  @override
  void initState() {
    _lastEntryFuture = DatabaseServiceAppData().getLastEntry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusBig)),
      child: FutureBuilder<StatsModel>(
        future: _lastEntryFuture,
        builder: (context, snapshot) {
          bool hasData = false;
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          }

          String lastMeditation = '';
          String lastMeditationDays = '';
          if (snapshot.hasData) {
            hasData = true;
            StatsModel lastEntry = snapshot.data!;
            lastMeditation =
                (lastEntry.totalMeditationTime).formatFromMilliseconds();
            DateTime now = DateTime.now();

            int daysSinceLastMeditation =
                now.difference(lastEntry.dateTime).inDays;

            if (daysSinceLastMeditation == 0) {
              lastMeditationDays = 'today';
            } else if (daysSinceLastMeditation == 1) {
              lastMeditationDays = 'yesterday';
            } else {
              lastMeditationDays = '$daysSinceLastMeditation days ago';
            }
          } else {
            lastMeditationDays = '0 days ago';
            lastMeditation = '0 minutes';
          }

          return FadeInAnimation(
            delayMilliseconds: kFadeInDelay,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: 'You last meditated ',
                style: Theme.of(context).textTheme.bodyLarge,
                children: [
                  TextSpan(
                    text: lastMeditationDays,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: hasData
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                        ),
                  ),
                  const TextSpan(
                    text: ' for ',
                  ),
                  TextSpan(
                    text: lastMeditation,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: hasData
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.surfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
