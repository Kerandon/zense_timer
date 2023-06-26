import 'dart:async';
import 'package:zense_timer/enums/clock_design.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:zense_timer/pages/home_page/center_timer/custom_clocks/custom_semi.dart';
import 'package:zense_timer/pages/home_page/center_timer/custom_clocks/custom_timer_background.dart';
import 'package:zense_timer/pages/home_page/center_timer/custom_clocks/custom_timer_dots.dart';
import 'package:zense_timer/pages/home_page/center_timer/timers/app_timer_main.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../configs/constants.dart';
import '../custom_clocks/custom_timer_clock.dart';
import '../custom_clocks/custom_timer_dash.dart';
import '../custom_clocks/custom_timer_line.dart';
import '../custom_clocks/custom_timer_solid.dart';

class CenterTimer extends ConsumerStatefulWidget {
  const CenterTimer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<CenterTimer> createState() => _CustomCircularIndicatorState();
}

class _CustomCircularIndicatorState extends ConsumerState<CenterTimer> {
  Timer? _timer;
  double _percent = 1.0;
  bool _pausePercentConfirmed = false;
  double _percentAdjustment = 0.01;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);

    /// FIXED TIME.
    if (!appState.openSession) {
      if (appState.sessionState == SessionState.inProgress) {
        final elapsedMinusCountdown =
            appState.elapsedTime - appState.countdownTime;
        _percent = elapsedMinusCountdown / appState.time;

        if (appState.reverseTimer) {
          _percent = 1 - _percent;
        }
      }

      if (appState.sessionState == SessionState.paused &&
          !_pausePercentConfirmed) {
        _pausePercentConfirmed = true;
      }
    }

    /// Reset at end
    if (appState.sessionState == SessionState.ended ||
        appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.notStarted) {
      _percentAdjustment = 0;
      _percent = 1.0;
    }

    ///Hides background of clock for non clock faces
    bool showBackground = false;
    if (appState.timerDesign == TimerDesign.clock) {
      showBackground = true;
    }
    if (appState.sessionState == SessionState.inProgress ||
        appState.sessionState == SessionState.paused) {
      showBackground = true;
    }

    final dimensions = 1 * size.width;
    final padding = 0.16 * size.width;

    int millisecondsRemaining =
        (appState.time + appState.countdownTime) - appState.elapsedTime;

    if (millisecondsRemaining < 50) {
      if (appState.reverseTimer) {
        _percent = 0;
      } else {
        _percent = 1;
      }
    }

    return Stack(
      children: [
        if (showBackground && appState.showTimer && !appState.openSession) ...[
          Center(
            child: SizedBox(
              height: dimensions,
              width: dimensions,
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: CustomPaint(
                  painter: CustomTimerBackground(
                    clockBackground: Theme.of(context)
                        .colorScheme
                        .shadow
                        .withOpacity(kBackgroundTimerOpacity),
                    clockLongTick: Theme.of(context).colorScheme.secondary,
                    timerDesign: appState.timerDesign,
                  ),
                ),
              ),
            ),
          ),
        ],
        if (appState.showTimer && !appState.openSession) ...[
          SizedBox(
            height: dimensions,
            width: dimensions,
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).colorScheme.tertiary,
              highlightColor: Theme.of(context).colorScheme.secondary,
              delay: const Duration(seconds: kShimmerDelay),
              child: Padding(
                padding: EdgeInsets.all(padding),
                child: CustomPaint(
                  painter: appState.timerDesign == TimerDesign.circle
                      ? CustomTimerSolid(
                          percentage: _percent - _percentAdjustment,
                        )
                      : appState.timerDesign == TimerDesign.clock
                          ? CustomTimeClock(
                              percentage: _percent - _percentAdjustment,
                            )
                          : appState.timerDesign == TimerDesign.dots
                              ? CustomTimerDots(
                                  percentage: _percent - _percentAdjustment,
                                )
                              : appState.timerDesign == TimerDesign.dash
                                  ? CustomTimerDash(
                                      percentage: _percent - _percentAdjustment,
                                    )
                                  : appState.timerDesign == TimerDesign.semi
                                      ? CustomSemi(
                                          percentage:
                                              _percent - _percentAdjustment,
                                        )
                                      : appState.timerDesign == TimerDesign.line
                                          ? CustomTimerLine(
                                              percentage:
                                                  _percent - _percentAdjustment,
                                            )
                                          : null,
                ),
              ),
            ),
          ),
        ],
        Center(
          child: Padding(
            padding: EdgeInsets.all(size.width * 0.05),
            child: const AppTimerMain(),
          ),
        )
      ],
    );
  }
}
