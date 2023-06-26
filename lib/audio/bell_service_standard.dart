import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibration/vibration.dart';

import '../configs/constants.dart';
import '../enums/interval_bell_type.dart';
import '../enums/session_state.dart';
import '../state/app_state.dart';
import '../state/audio_state.dart';

class BellServiceStandard extends ConsumerStatefulWidget {
  const BellServiceStandard({Key? key}) : super(key: key);

  @override
  ConsumerState<BellServiceStandard> createState() =>
      _BellServiceStandardState();
}

class _BellServiceStandardState extends ConsumerState<BellServiceStandard> {
  bool _bellsAreSet = false;
  final _playerStart = AudioPlayer();
  final _playerInterval = AudioPlayer();
  final _playerEnd1 = AudioPlayer();
  final _playerEnd2 = AudioPlayer();
  Timer? _timerStart, _timerInterval, _timerEnd1, _timerEnd2;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);

    if (appState.sessionState == SessionState.notStarted) {
      _reset();
    }

    /// COUNTDOWN OR IN-PROGRESS
    /// Set bell times
    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      if (!_bellsAreSet) {
        _bellsAreSet = true;
        if (audioState.bellType == BellType.fixed) {
          _setFixedBells(appState: appState, audioState: audioState);
        } else {
          _setRandomBells(audioState: audioState, appState: appState);
        }
        _setEndBells(appState: appState, audioState: audioState);
      }
    }

    return const SizedBox.shrink();
  }

  Future<void> _setFixedBells(
      {required AppState appState, required AudioState audioState}) async {
    int time = appState.openSession ? kOpenSessionMaxTime : appState.time;

    int totalIntervalBells = 0;
    int timeToStart = 0;

    /// on FIRST START
    if (appState.elapsedTime == 0) {
      timeToStart = appState.countdownTime;
      if (audioState.bellFixedTime > 0) {
        totalIntervalBells = (time ~/ audioState.bellFixedTime) - 1;
      }
    } else {
      /// on RESUME
      final remainingTime = time - appState.elapsedTime;

      totalIntervalBells =
          (remainingTime / audioState.bellFixedTime).floor() - 1;

      timeToStart = remainingTime;

      for (int i = 0; i < (totalIntervalBells + 1); i++) {
        timeToStart -= audioState.bellFixedTime;
      }
    }

    print('time to start ${timeToStart} and tot bells $totalIntervalBells');

    bool bellOnStart = appState.elapsedTime == 0
        ? audioState.bellOnStartSound.name != kNone
        : true;

    /// Bell on start sound (set to interval sound if resuming)
    String startSound = appState.elapsedTime == 0
        ? audioState.bellOnStartSound.name
        : audioState.bellIntervalSound.name;

    _timerStart = Timer(Duration(milliseconds: timeToStart), () async {
      if (bellOnStart) {
        await _playerStart
            .setAsset('assets/audio/bells/${startSound}.mp3')
            .then((value) async {
          await _playerStart.play();
        });
      }
      _timerInterval = Timer.periodic(
          Duration(milliseconds: audioState.bellFixedTime), (timer) async {
        await _playerInterval
            .setAsset(
                'assets/audio/bells/${audioState.bellIntervalSound.name}.mp3')
            .then((value) async {
          _playerInterval.play();
        });
        totalIntervalBells--;
        print('total interval bells $totalIntervalBells');
        if (totalIntervalBells == 0) {
          print('CANCEL');
          timer.cancel();
        }
      });
    });
  }

  Future<void> _setRandomBells(
      {required AppState appState, required AudioState audioState}) async {
    int time = appState.openSession ? kOpenSessionMaxTime : appState.time;

    final timeToEnd = appState.elapsedTime == 0
        ? appState.countdownTime + time
        : time - appState.elapsedTime;

    await _playerStart
        .setAsset('assets/audio/bells/${audioState.bellOnStartSound.name}.mp3')
        .then((value) async {
      _playerStart.setVolume(audioState.bellVolume);
    });
    if (audioState.bellOnStartSound.name != kNone &&
        appState.elapsedTime == 0) {
      _timerStart =
          Timer(Duration(milliseconds: appState.countdownTime), () async {
        await _playerStart.seek(Duration.zero);
        await _playerStart.play();
      });
    }

    Future<void> calculateRandomTime(
        int minRandomTime, int maxRandomTime) async {
      Random random = Random();
      Duration duration = Duration(
          milliseconds:
              random.nextInt(maxRandomTime - minRandomTime) + minRandomTime);
      print('RANDOM TIME SET TO ${duration.inMilliseconds}');
      _timerInterval = Timer(duration, () async {
        await _playerInterval.seek(Duration.zero);
        await _playerInterval.play();
        calculateRandomTime(minRandomTime, maxRandomTime);
      });
    }

    Timer(Duration(milliseconds: timeToEnd - 15000), () {
      print('timer cancelled');
      _timerInterval?.cancel();
    });

    calculateRandomTime(audioState.bellRandom.min,
        audioState.bellRandom.max == 60000 ? 45000 : audioState.bellRandom.max);
  }

  Future<void> _setEndBells(
      {required AppState appState, required AudioState audioState}) async {
    int time = appState.openSession ? kOpenSessionMaxTime : appState.time;

    final timeToEnd = appState.elapsedTime == 0
        ? appState.countdownTime + time
        : time - appState.elapsedTime;

    await _playerEnd1
        .setAsset('assets/audio/bells/${audioState.bellOnEndSound.name}.mp3')
        .then((value) async {
      _playerEnd1.setVolume(audioState.bellVolume);
    });
    await _playerEnd2
        .setAsset('assets/audio/bells/${audioState.bellOnEndSound.name}.mp3')
        .then((value) async {
      _playerEnd2.setVolume(audioState.bellVolume);
    });

    _timerEnd1 = Timer(Duration(milliseconds: timeToEnd), () async {
      await _playerEnd1.play();

      if (appState.vibrate) {
        await Vibration.vibrate(duration: 3000);
      }
    });

    _timerEnd2 = Timer(Duration(milliseconds: timeToEnd + kEndBellGap), () async {
      await _playerEnd2.play();
    });
  }

  Future<void> _reset() async {
    await _playerStart.stop();
    await _playerInterval.stop();
    await _playerEnd1.stop();
    await _playerEnd2.stop();
    _bellsAreSet = false;
    _timerStart?.cancel();
    _timerInterval?.cancel();
    _timerEnd1?.cancel();
    _timerEnd2?.cancel();

  }
}
