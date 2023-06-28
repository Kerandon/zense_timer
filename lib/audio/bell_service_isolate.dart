import 'dart:async';
import 'dart:math';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:vibration/vibration.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/interval_bell_type.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../enums/session_state.dart';
import '../state/app_state.dart';
import '../state/audio_state.dart';

/// PLAY FIXED BELLS
@pragma('vm:entry-point')
void playFixedBellsIsolate(dynamic args) {
  int timeToStart = args[0];
  bool bellOnStart = args[1];
  String startSound = args[2];
  String intervalSound = args[3];
  int intervalTime = args[4];
  double volume = args[5];
  int timeToEnd = args[6];

  final bellPlayer1 = AudioPlayer();
  final bellPlayer2 = AudioPlayer();
  bellPlayer1.setAsset('assets/audio/bells/$startSound.mp3').then((value) {
    bellPlayer1.setVolume(volume);
  });
  bellPlayer2.setAsset('assets/audio/bells/$intervalSound.mp3').then((value) {
    bellPlayer2.setVolume(volume);
  });

  Timer? periodicTimer;

  Timer(Duration(milliseconds: timeToStart), () {
    if (bellOnStart) {
      bellPlayer1.play();
    }
    periodicTimer =
        Timer.periodic(Duration(milliseconds: intervalTime), (timer) {
      bellPlayer2.seek(Duration.zero);
      if (timeToEnd > kEndBellCutOff) {
        bellPlayer2.play();
      }
    });
  });

  Timer(Duration(milliseconds: timeToEnd - kEndBellCutOff), () {
    periodicTimer?.cancel();
  });
}

/// PLAY RANDOM BELLS
@pragma('vm:entry-point')
void playRandomBells(dynamic args) {
  int timeToStart = args[0];
  bool bellOnStart = args[1];
  String startSound = args[2];
  String intervalSound = args[3];
  int minRandom = args[4];
  int maxRandom = args[5];
  int timeToEnd = args[6];
  double volume = args[7];
  final bellPlayer1 = AudioPlayer();
  final bellPlayer2 = AudioPlayer();
  if (timeToEnd == 60000) {
    maxRandom = (60000 - kEndBellCutOff);
  }

  bellPlayer1.setAsset('assets/audio/bells/$startSound.mp3').then((value) {
    bellPlayer1.setVolume(volume);
  });
  bellPlayer2.setAsset('assets/audio/bells/$intervalSound.mp3').then((value) {
    bellPlayer2.setVolume(volume);
  });

  if (bellOnStart) {
    Timer(Duration(milliseconds: timeToStart), () {
      bellPlayer1.seek(Duration.zero);
      bellPlayer1.play();
    });
  }

  Timer? bellTimer;

  void calculateRandomTime(int minRandomTime, int maxRandomTime) {
    Random random = Random();
    Duration duration = Duration(
        milliseconds:
            random.nextInt(maxRandomTime - minRandomTime) + minRandomTime);

    bellTimer = Timer(duration, () {
      bellPlayer2.seek(Duration.zero);
      bellPlayer2.play();
      calculateRandomTime(minRandom, maxRandomTime);
    });
  }

  Timer(Duration(milliseconds: timeToEnd - kEndBellCutOff), () {
    bellTimer?.cancel();
  });

  calculateRandomTime(minRandom, maxRandom);
}

/// END BELL ISOLATE
@pragma('vm:entry-point')
void playEndBell(dynamic args) {
  String endSound = args[0];
  int time = args[1];
  bool vibrate = args[2];
  double volume = args[3];
  final bellPlayer1 = AudioPlayer();
  final bellPlayer2 = AudioPlayer();
  bellPlayer1.setAsset('assets/audio/bells/$endSound.mp3').then((value) {
    bellPlayer1.setVolume(volume);
  });
  bellPlayer2.setAsset('assets/audio/bells/$endSound.mp3').then((value) {
    bellPlayer2.setVolume(volume);
  });

  ///End bell - plays 2 bells & also vibrates is [true]
  Timer(Duration(milliseconds: time), () {
    bellPlayer1.play();

    if (vibrate) {
      Vibration.vibrate(duration: kVibrateDuration);
    }
  });

  Timer(Duration(milliseconds: time + kEndBellGap), () {
    bellPlayer2.play();
  });
}

class BellServiceIsolate extends ConsumerStatefulWidget {
  const BellServiceIsolate({Key? key}) : super(key: key);

  @override
  ConsumerState<BellServiceIsolate> createState() => _BellService2State();
}

class _BellService2State extends ConsumerState<BellServiceIsolate> {
  bool _bellsAreSet = false;

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
          _setRandomBells(audioState, appState);
        }
        _setEndBell(appState: appState, audioState: audioState);
      }
    }
    if (appState.sessionState == SessionState.paused) {
      _bellsAreSet = false;
      _reset();
    }
    return const SizedBox.shrink();
  }

  void _setFixedBells(
      {required AppState appState, required AudioState audioState}) {
    /// Work out time
    int time = appState.openSession ? kOpenSessionMaxTime : appState.time;

    int totalIntervalBells = 0;
    int timeToStart = 0;

    /// on START
    if (appState.elapsedTime == 0) {
      timeToStart = appState.countdownTime;
      if (audioState.bellFixedTime > 0) {
        totalIntervalBells = (time ~/ audioState.bellFixedTime) - 1;
      }
    } else {
      /// on RESUME
      final remainingTime =
          time - (appState.elapsedTime - appState.countdownTime);
      totalIntervalBells =
          (remainingTime / audioState.bellFixedTime).floor() - 1;
      timeToStart = remainingTime;

      for (int i = 0; i < (totalIntervalBells + 1); i++) {
        timeToStart -= audioState.bellFixedTime;
      }
    }

    /// Time to end
    final timeToEnd = appState.elapsedTime == 0
        ? appState.countdownTime + time
        : time - (appState.elapsedTime + appState.countdownTime);

    final fixedVariables = [
      timeToStart,

      /// Bell on start [bool]
      appState.elapsedTime == 0
          ? audioState.bellOnStartSound.name != kNone
          : !timeToStart.isNegative,

      /// Bell on start sound (set to interval sound if resuming)
      appState.elapsedTime == 0
          ? audioState.bellOnStartSound.name
          : audioState.bellIntervalSound.name,

      /// Interval sound
      audioState.bellIntervalSound.name,

      /// Fixed interval time
      audioState.bellFixedTime,

      /// Volume
      audioState.bellVolume,

      ///Time to end
      timeToEnd,
    ];

    if (timeToEnd > kEndBellCutOff) {
      FlutterIsolate.spawn(playFixedBellsIsolate, fixedVariables);
    }
  }

  void _setRandomBells(AudioState audioState, AppState appState) {
    int time = appState.openSession ? kOpenSessionMaxTime : appState.time;

    final timeToEnd = appState.elapsedTime == 0
        ? appState.countdownTime + time
        : time - (appState.elapsedTime + appState.countdownTime);

    if (timeToEnd > kEndBellCutOff) {
      FlutterIsolate.spawn(playRandomBells, [
        /// Time to start
        appState.countdownTime,

        /// Bell on start
        audioState.bellOnStartSound.name != kNone && appState.elapsedTime == 0,

        /// Start sound
        audioState.bellOnStartSound.name,

        /// Interval sound
        audioState.bellIntervalSound.name,

        /// Min and Max Range
        audioState.bellRandom.min,
        audioState.bellRandom.max,

        /// Time to end
        timeToEnd,

        /// Bell volume
        audioState.bellVolume,
      ]);
    }
  }

  void _setEndBell(
      {required AppState appState, required AudioState audioState}) {
    int time = appState.time;
    if (appState.openSession) {
      time = kOpenSessionMaxTime;
    }

    FlutterIsolate.spawn(playEndBell, [
      audioState.bellOnEndSound.name,
      appState.elapsedTime == 0
          ? appState.countdownTime + time
          : time - appState.elapsedTime + appState.countdownTime,
      appState.vibrate,
      audioState.bellVolume,
    ]);
  }

  void _reset() {
    FlutterIsolate.killAll();
  }
}
