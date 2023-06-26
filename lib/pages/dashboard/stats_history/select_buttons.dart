import 'package:zense_timer/pages/dashboard/stats_history/remove_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_button.dart';
import '../../../models/stats_model.dart';
import '../../../state/chart_state.dart';

class SelectButtons extends ConsumerWidget {
  const SelectButtons({
    super.key,
    required this.stats,
  });

  final List<StatsModel> stats;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);

    Map<int, DateTime> items = {};
    for (int i = 0; i < stats.length; i++) {
      items.addAll({i: stats[i].dateTime});
    }

    return Padding(
      padding: EdgeInsets.all(
        size.width * 0.03,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    text: 'Select all',
                    isSelected:
                        state.selectedMeditationEvents.length != stats.length,
                    onPressed: () =>
                        notifier.selectMeditationEvents(items: items)),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomButton(
                    text: 'Unselect all',
                    isSelected: state.selectedMeditationEvents.isNotEmpty,
                    onPressed: () => notifier.selectMeditationEvents(
                        items: items, unselect: true)),
              ),
            ],
          ),
          Row(
            children: [
              if (state.selectedMeditationEvents.isNotEmpty)
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              RemoveConfirmationDialog(items: items));
                    },
                    icon: Icon(
                      Icons.delete_outline_outlined,
                      color: state.selectedMeditationEvents.isEmpty
                          ? Theme.of(context).colorScheme.onSurfaceVariant
                          : Theme.of(context).colorScheme.primary,
                      size: 35,
                    ))
              else
                const SizedBox.shrink(),
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.02),
                child: state.selectedMeditationEvents.isNotEmpty
                    ? Text(
                        '(${state.selectedMeditationEvents.length.toString()})',
                        style: Theme.of(context).textTheme.bodyLarge,
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          )
        ],
      ),
    );
  }
}
