import 'package:zense_timer/state/chart_state.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../models/stats_model.dart';

class StatsEventTile extends ConsumerWidget {
  const StatsEventTile({
    super.key,
    required this.stat,
    required this.index,
  });

  final StatsModel stat;
  final int index;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    final formatterDate = DateFormat.yMMMMEEEEd();
    final formatterTime = DateFormat.jm();
    final formattedDate =
        '${formatterTime.format(stat.dateTime)} on ${formatterDate.format(stat.dateTime)}';

    final duration =
        'Meditated for ${(stat.totalMeditationTime).formatFromMilliseconds()}';

    return CheckboxListTile(
      title: RichText(
        text: TextSpan(
          text: duration,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold),
        ),
      ),
      subtitle: Text(formattedDate),
      value: state.selectedMeditationEvents.containsKey(index),
      onChanged: (value) {
        if (value == true) {
          notifier.selectMeditationEvents(items: {index: stat.dateTime});
        } else {
          notifier.selectMeditationEvents(
              items: {index: stat.dateTime}, unselect: true);
        }
      },
    );
  }
}
