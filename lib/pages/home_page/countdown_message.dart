import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/constants.dart';
import '../../enums/app_color_themes.dart';
import '../../enums/session_state.dart';

class CountdownMessage extends ConsumerWidget {
  const CountdownMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);

    return Align(
        alignment: const Alignment(0, -0.90),
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    if (appState.colorTheme != AppColorTheme.simple) ...[
                      Theme.of(context)
                          .colorScheme
                          .primary
                          .withOpacity(kHomeScreenBackdropOpacity),
                      Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(kHomeScreenBackdropOpacity),
                    ],
                    if (appState.colorTheme == AppColorTheme.simple) ...[
                      if (appState.sessionState == SessionState.notStarted) ...[
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(kHomeScreenBackdropOpacity),
                        Theme.of(context)
                            .colorScheme
                            .surface
                            .withOpacity(kHomeScreenBackdropOpacity),
                      ] else ...[
                        Colors.transparent,
                        Colors.transparent
                      ]
                    ],
                  ]),
              borderRadius: BorderRadius.circular(kBorderRadiusBig)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              kSessionWillBeginShortly,
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: appState.colorTheme == AppColorTheme.simple &&
                          !appState.darkTheme
                      ? Colors.black
                      : Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        )).animate().fadeIn(duration: kFadeInTimeSlow.milliseconds * 5);
  }
}
