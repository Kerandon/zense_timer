import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/prefs.dart';
import '../../../state/app_state.dart';
import '../../../state/database_service.dart';

class CountdownChecklist extends ConsumerWidget {
  const CountdownChecklist({
    required this.countdownTime,
    super.key,
  });

  final int countdownTime;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    String title = "";

    if (countdownTime == 0) {
      title = 'None';
    }

    if (countdownTime > 0 && countdownTime < 600000) {
      title = '${countdownTime ~/ 1000} seconds';
    }
    if (countdownTime >= 60000) {
      title = '${countdownTime ~/ 60000} minute';
    }

    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 1,
        maxWidth: size.width,
      ),
      child: CheckboxListTile(
        title: Text(
          title,
        ),
        value: state.countdownTime == countdownTime,
        onChanged: (value) async {
          notifier.setCountdownTime(countdownTime);
          await DatabaseServiceAppData()
              .insertIntoPrefs(k: Prefs.countdownTime.name, v: countdownTime);
        },
      ),
    );
  }
}
