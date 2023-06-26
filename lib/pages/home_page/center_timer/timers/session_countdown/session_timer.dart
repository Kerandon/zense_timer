import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../../enums/session_state.dart';
import '../../../../../state/app_state.dart';
import '../set_time_dialog/set_time_dialog.dart';
import 'colon.dart';
import 'number_box.dart';

class SessionTimer extends ConsumerStatefulWidget {
  const SessionTimer({
    super.key,
  });

  @override
  ConsumerState<SessionTimer> createState() => _SessionClockState();
}

class _SessionClockState extends ConsumerState<SessionTimer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (state.time < 60000) {
        notifier.setTime(minutes: 1, hours: 0);
      }
    });

    int hours = 0;
    int minutes = 0;
    int seconds = 0;

    if (state.sessionState == SessionState.notStarted && !state.openSession) {
      hours = state.time ~/ 3600000; // Integer division by 3600000 to get hours
      minutes = (state.time % 3600000) ~/
          60000; // Modulo by 3600000 to get remaining milliseconds, then integer division by 60000 to get minutes
      seconds = (state.time % 60000) ~/
          1000; // Modulo by 60000 to get remaining milliseconds, then integer division by 1000 to get seconds
    }

    int remainingCountdownTime = 0;
    if (state.sessionState == SessionState.countdown) {
      remainingCountdownTime = (state.countdownTime - state.elapsedTime) + 1000;

      /// Cap [millisecondsRemaining] to not higher than [state.totalTimeMinutes]
      if (remainingCountdownTime > state.countdownTime) {
        remainingCountdownTime = state.countdownTime;
      }

      /// Prevents [millisecondsRemaining] reaching zero
      if (remainingCountdownTime < 1000) {
        remainingCountdownTime = 1000;
      }

      minutes = (remainingCountdownTime % 3600000) ~/ 60000;
      seconds = ((remainingCountdownTime % 60000) ~/ 1000);
    }

    int remainingTimeMinusCountdown =
        (state.time - state.elapsedTime + state.countdownTime) + 1000;

    int elapsedMinusCountdown = state.elapsedTime - state.countdownTime;

    if (state.sessionState == SessionState.inProgress) {
      if (!state.openSession) {
        /// Cap [millisecondsRemaining] to not higher than [state.totalTimeMinutes]
        if (remainingTimeMinusCountdown > state.time) {
          remainingTimeMinusCountdown = state.time;
        }

        hours = remainingTimeMinusCountdown ~/ 3600000;
        minutes = (remainingTimeMinusCountdown % 3600000) ~/ 60000;
        seconds = (remainingTimeMinusCountdown % 60000) ~/ 1000;
      } else {
        hours = elapsedMinusCountdown ~/ 3600000;
        minutes = (elapsedMinusCountdown % 3600000) ~/ 60000;
        seconds = (elapsedMinusCountdown % 60000) ~/ 1000;
      }
    }
    if (state.sessionState == SessionState.paused) {
      if (!state.openSession) {
        hours = remainingTimeMinusCountdown ~/ 3600000;
        minutes = (remainingTimeMinusCountdown ~/ 60000) % 60;
        seconds = (remainingTimeMinusCountdown ~/ 1000) % 60;
      } else {
        hours = elapsedMinusCountdown ~/ 3600000;
        minutes = (elapsedMinusCountdown ~/ 60000) % 60;
        seconds = (elapsedMinusCountdown ~/ 1000) % 60;
      }
    }

    String hourL = '0';
    String hourR = '0';
    String minL = '0';
    String minR = '0';
    String secL = '0';
    String secR = '0';

    if (hours > 9) {
      hourR = hours.toString()[1];
      hourL = hours.toString()[0];
    }
    if (hours <= 9) {
      hourR = hours.toString()[0];
    }

    if (minutes > 9) {
      minR = minutes.toString()[1];
      minL = minutes.toString()[0];
    }
    if (minutes <= 9) {
      minR = minutes.toString()[0];
    }

    if (seconds > 9) {
      secR = seconds.toString()[1];
      secL = seconds.toString()[0];
    }
    if (seconds <= 9) {
      secR = seconds.toString()[0];
    }

    if (state.sessionState == SessionState.countdown &&
        remainingCountdownTime >= 60000) {
      secL = '6';
    }

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(1000),
        child: Container(
          width: size.width * 0.58,
          height: size.width * 0.58,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  if (state.colorTheme == AppColorTheme.simple) ...[
                    if (state.sessionState == SessionState.notStarted) ...[
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
                  ] else if (state.colorTheme != AppColorTheme.simple) ...[
                    Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(kHomeScreenBackdropOpacity),
                    Theme.of(context)
                        .colorScheme
                        .tertiary
                        .withOpacity(kHomeScreenBackdropOpacity),
                  ]
                ]),
            borderRadius: BorderRadius.circular(1000),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: state.sessionState == SessionState.notStarted
                  ? () {
                      showDialog(
                          context: context,
                          builder: (context) => const SetTimeDialog());
                    }
                  : null,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (!(state.openSession &&
                      state.sessionState == SessionState.notStarted)) ...[
                    /// SESSION TIMER
                    if ((state.openSession || state.time >= 60) &&
                        state.sessionState != SessionState.countdown) ...[
                      NumberBox(hourL),
                      NumberBox(hourR),
                      const Colon()
                    ],
                    if (state.sessionState != SessionState.countdown) ...[
                      NumberBox(minL),
                      NumberBox(minR),
                      const Colon(),
                    ],
                    NumberBox(secL),
                    NumberBox(secR),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
    //.animate().fadeIn(duration: kFadeInTimeMilliseconds.milliseconds);
  }
}
