import 'package:zense_timer/animation/pop_animation.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../app_components/popup.dart';
import '../../../enums/app_color_themes.dart';
import '../../../enums/session_state.dart';
import '../../../state/app_state.dart';
import '../../../state/audio_state.dart';

class StartButton extends ConsumerWidget {
  const StartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioNotifier = ref.read(audioProvider.notifier);
    final size = MediaQuery.of(context).size;

    return PopAnimation(
      animate: appState.appHasLoaded &&
          appState.sessionState == SessionState.notStarted,
      reset: appState.sessionState == SessionState.countdown ||
          appState.sessionState == SessionState.inProgress ||
          appState.sessionState == SessionState.paused,
      child: SizedBox(
        width: size.width * 0.80,
        height: size.height * 0.09,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(kBorderRadiusBig),
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusBig),
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    if (appState.colorTheme == AppColorTheme.simple) ...[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primary,
                    ] else if (appState.colorTheme != AppColorTheme.simple) ...[
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary,
                    ]
                  ]),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  audioNotifier.setShowAmbience(false);
                  appNotifier.setShowPresets(false);

                  WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                    /// Check that [appState.time] isn't zero, if a fixed time session
                    if (appState.sessionState == SessionState.notStarted &&
                        appState.time > 0) {
                      if (appState.time == 0 && !appState.openSession) {
                        showPopup(
                            context: context,
                            text: kSetFixedTimeGreaterThanZero);
                      } else {
                        if (appState.countdownTime > 0) {
                          appNotifier.setSessionState(SessionState.countdown);
                        } else {
                          appNotifier.setSessionState(SessionState.inProgress);
                        }
                      }
                    }
                  });
                },
                child: Center(
                  child: Text(
                    'START',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
