import 'package:zense_timer/app_components/custom_button.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../animation/fade_in_animation.dart';
import '../../../../../app_components/animated_icons/animated_infinity_icon.dart';
import '../../../../../app_components/dialog_switch_list_tile.dart';
import '../../../../../configs/constants.dart';
import 'time_picker_main.dart';

class SetTimeDialog extends ConsumerWidget {
  const SetTimeDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    return FadeInAnimation(
      durationMilliseconds: kFadeInTimeFast,
      beginScale: 0.80,
      child: AlertDialog(
        contentPadding: EdgeInsets.all(size.width * 0.05),
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.02),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              DialogSwitchListTile(
                text: 'Open-ended session',
                value: appState.openSession,
                onChanged: (on) {
                  appNotifier.setOpenSession(on);
                },
              ),
              if (appState.openSession) ...[
                SizedBox(
                  height: size.height * 0.30,
                  width: size.width * 0.80,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text('$kOpenSessionText\n'),
                      SizedBox(
                          height: size.height * 0.20,
                          child: AnimatedInfinityIcon(
                            color: Theme.of(context).colorScheme.onSurface,
                          ))
                    ],
                  ).animate().fadeIn(duration: kFadeInTimeFast.milliseconds),
                )
              ],
              if (!appState.openSession) ...[
                SizedBox(
                    height: size.height * 0.30,
                    width: size.width * 0.80,
                    child: const TimePickerMain())
              ]
            ],
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          SizedBox(
              width: size.width * 0.50,
              height: size.height * 0.06,
              child: CustomButton(
                  onPressed: appState.time == 0
                      ? null
                      : () {
                          Navigator.of(context).maybePop();
                        },
                  text: 'Set')),
        ],
      ),
    );
  }
}
