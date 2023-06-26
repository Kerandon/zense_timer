import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_button.dart';
import '../../../app_components/loading_helper.dart';
import '../../../state/chart_state.dart';
import '../../../state/database_service.dart';
import 'stats_history_page.dart';

class RemoveConfirmationDialog extends ConsumerWidget {
  const RemoveConfirmationDialog({
    super.key,
    required this.items,
  });

  final Map<int, DateTime> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartStateProvider);
    return AlertDialog(
      title: Text(
        'Delete selected meditation records?\n',
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.bold,
            ),
        textAlign: TextAlign.center,
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        CustomButton(
            setToBackgroundColor: true,
            onPressed: () async {
              List<DateTime> dateTimes = [];
              for (var i in state.selectedMeditationEvents.values) {
                dateTimes.add(i);
              }
              Navigator.of(context, rootNavigator: true).pop('dialog');

              showDialog(
                  context: context,
                  builder: (context) => LoadingHelper(
                        future: DatabaseServiceAppData().removeStats(dateTimes),
                        onComplete: () {
                          Future.delayed(const Duration(seconds: 0), () async {
                            await Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const StatsHistoryPage()));
                          });
                        },
                      ));
            },
            text: 'Yes'),
        CustomButton(
            setToBackgroundColor: true,
            onPressed: () async {
              await Navigator.of(context).maybePop();
            },
            text: 'Cancel')
      ],
    );
  }
}
