import 'package:zense_timer/enums/session_state.dart';
import 'package:zense_timer/pages/home_page/center_timer/timers/session_countdown/session_timer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:quiver/async.dart';
import '../../../../app_components/animated_icons/animated_infinity_icon.dart';
import '../../../../configs/constants.dart';
import '../../../../enums/app_color_themes.dart';
import '../../../../state/app_state.dart';
import '../../../../state/database_service.dart';
import '../../../completion_page/completion_page.dart';

class AppTimerMain extends ConsumerStatefulWidget {
  const AppTimerMain({
    super.key,
  });

  @override
  ConsumerState<AppTimerMain> createState() => _CustomNumberFieldState();
}

class _CustomNumberFieldState extends ConsumerState<AppTimerMain> {
  bool _timerIsSet = false;
  bool _countdownHasFinished = false;
  static CountdownTimer? _appStateTimer;
  bool _endSessionNotified = false;

  @override
  void dispose() {
    _appStateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    /// Reset variables when session has completed.
    if (appState.sessionState == SessionState.notStarted) {
      _countdownHasFinished = false;
      _timerIsSet = false;

      _appStateTimer?.cancel();

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setElapsedTime(0);
      });
    }

    /// COUNTDOWN STATE ONLY
    if (appState.sessionState == SessionState.countdown) {
      /// This changes the [appState] from [countdown] to [inProgress] once the countdown has finished.
      if (appState.elapsedTime > (appState.countdownTime)) {
        if (!_countdownHasFinished) {
          _countdownHasFinished = true;
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            appNotifier.setSessionState(SessionState.inProgress);
          });
        }
      }
    }

    /// COUNTDOWN OR IN-PROGRESS STATES
    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      if (!_timerIsSet) {
        /// FIXED TIME
        if (!appState.openSession) {
          int t = 0;
          t = appState.time + appState.countdownTime;

          _appStateTimer = CountdownTimer(
              Duration(milliseconds: t), const Duration(milliseconds: 1))
            ..listen((event) {
              appNotifier.setElapsedTime(
                  event.elapsed.inMilliseconds + appState.elapsedTime);
            });
          _timerIsSet = true;
        } else {
          _appStateTimer = CountdownTimer(
              const Duration(milliseconds: kOpenSessionMaxTime),
              const Duration(milliseconds: 1))
            ..listen((event) {
              appNotifier.setElapsedTime(
                  (event.elapsed.inMilliseconds + appState.elapsedTime));
            });

          _timerIsSet = true;
        }
      }
    }

    /// PAUSED STATE
    if (appState.sessionState == SessionState.paused) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _appStateTimer?.cancel();
        _timerIsSet = false;
      });
    }

    /// End session if remaining milliseconds is within 100 of the end time.
    int millisecondsRemaining = 0;
    if (appState.openSession) {
      millisecondsRemaining =
          (kOpenSessionMaxTime + appState.countdownTime) - appState.elapsedTime;
    } else {
      millisecondsRemaining =
          (appState.time + appState.countdownTime) - appState.elapsedTime;
    }

    if (appState.sessionState == SessionState.inProgress &&
        !_endSessionNotified &&
        millisecondsRemaining <= 20) {
      DatabaseServiceAppData().insertIntoStats(
          dateTime: DateTime.now(), milliseconds: appState.time);
      _endSessionNotified = true;

      /// Notify to to change state to [ended]
      Future.delayed(const Duration(milliseconds: 0), () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const CompletionPage()));
      });
    }

    /// Fade out ambience if was playing
    if (appState.sessionState == SessionState.ended) {
      _appStateTimer?.cancel();
    }

    return Stack(
      children: [
        const Align(
          child: SessionTimer(),
        ),
        if (appState.sessionState == SessionState.notStarted) ...[
          IgnorePointer(
            child: Align(
              alignment: const Alignment(0, 0.30),
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Text(
                  'SET TIME',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: !appState.darkTheme &&
                                appState.colorTheme == AppColorTheme.simple
                            ? Colors.black
                            : Colors.white,
                      ),
                ),
              ),
            ),
          ),
        ],
        if (appState.openSession &&
            appState.sessionState == SessionState.notStarted) ...[
          Align(
            child: SizedBox(
              width: size.width * kAppTimerWidth,
              child: AnimatedInfinityIcon(
                strokeWidth: size.width * 0.1,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
