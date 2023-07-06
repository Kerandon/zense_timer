import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/pages/completion_page/completion_page.dart';
import 'package:zense_timer/pages/home_page/control_buttons/control_button.dart';
import 'package:zense_timer/pages/home_page/control_buttons/start_button.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../enums/session_state.dart';
import '../../../state/app_state.dart';
import '../../../state/database_service.dart';
import '../home.dart';

class ControlButtons extends ConsumerStatefulWidget {
  const ControlButtons({Key? key}) : super(key: key);

  @override
  ConsumerState<ControlButtons> createState() => _ControlButtonsState();
}

class _ControlButtonsState extends ConsumerState<ControlButtons> {
  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);

    return Stack(
      children: [
        /// START BUTTON
        const Align(alignment: Alignment(0, 0.65), child: StartButton()),

        /// STOP BUTTON
        if (appState.sessionState != SessionState.notStarted && appState.sessionState != SessionState.ended) ...[
          Align(
            alignment: const Alignment(0.65, 0.90),
            child: FadeInAnimation(
              child: ControlButton(
                color: appState.colorTheme == AppColorTheme.simple &&
                        !appState.darkTheme
                    ? Colors.black
                    : Colors.white,
                icon: Icons.stop_outlined,
                onPressed: () async {
                  appNotifier.setAppWasStopped(true);

                  /// Go back to [appState.notStarted] if during COUNTDOWN

                  if (appState.sessionState == SessionState.countdown) {
                    _cancelSession(appNotifier, context);
                  } else {
                    /// If time elapsed is greater than 1 minute - show completion page and save stats.
                    if ((appState.elapsedTime - appState.countdownTime) >=
                        60000) {
                      /// Insert into stats
                      ///
                      await DatabaseServiceAppData().insertIntoStats(
                          dateTime: DateTime.now(),
                          milliseconds:
                              appState.elapsedTime - appState.countdownTime);

                      if (mounted) {
                        await Navigator.of(context).pushAndRemoveUntil(
                            PageRouteBuilder(
                              pageBuilder: (_, __, ___) =>
                                  const CompletionPage(),
                            ),
                            (route) => false);
                      }
                    } else {
                      _cancelSession(appNotifier, context);
                    }
                  }
                },
              ),
            ),
          ),

          /// PAUSE BUTTON
          Align(
            alignment: const Alignment(-0.65, 0.90),
            child: FadeInAnimation(
              animateOnDemand: appState.sessionState == SessionState.countdown ||
                  appState.sessionState == SessionState.inProgress,
              // reset: appState.sessionState == SessionState.notStarted,
              child: ControlButton(
                color: appState.sessionState == SessionState.countdown
                    ? Theme.of(context).colorScheme.onSurface.withOpacity(0.40)
                    : appState.colorTheme == AppColorTheme.simple &&
                            !appState.darkTheme
                        ? Colors.black
                        : Colors.white,
                disable: appState.sessionState == SessionState.countdown,
                icon: appState.sessionState == SessionState.paused
                    ? Icons.play_arrow_outlined
                    : Icons.pause_outlined,
                onPressed: () {
                  if (appState.sessionState == SessionState.inProgress) {
                    appNotifier.setSessionState(SessionState.paused);
                  }
                  if (appState.sessionState == SessionState.paused) {
                    appNotifier.setSessionState(SessionState.inProgress);
                  }
                },
              ),
            ),
          ),
        ],
      ],
    );
  }

  void _cancelSession(AppNotifier appNotifier, BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      appNotifier.setSessionState(SessionState.notStarted);
      await Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
          ),
          (route) => false);
    });
  }
}
