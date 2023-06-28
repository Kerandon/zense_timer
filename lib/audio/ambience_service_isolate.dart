import 'dart:async';
import 'dart:isolate';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiver/async.dart';
import '../configs/constants.dart';
import '../state/app_state.dart';
import '../state/audio_state.dart';

@pragma('vm:entry-point')
void playAmbience(dynamic args) {
  String ambience = args[0];
  double volume = args[1];
  int position = args[2];
  int countdown = args[3];
  int sessionTimeRemaining = args[4];
  SendPort sendPort = args[5];

  if (ambience == kNone) {
    ambience = 'blank';
  }

  /// Countdown player to play 'white noise' if a countdown is set so the OS will next kill the app if backgrounded.
  final countdownPlayer = AudioPlayer();
  countdownPlayer.setAsset('assets/audio/ambience/blank.mp3').then((value) {
    countdownPlayer.setVolume(0.01);
    countdownPlayer.setLoopMode(LoopMode.all);
    countdownPlayer.play();
  });

  Timer(Duration(milliseconds: countdown + 5000),(){
    countdownPlayer.stop();
  });


  final ambiencePlayer = AudioPlayer();
  ambiencePlayer.setAsset('assets/audio/ambience/$ambience.mp3');
  ambiencePlayer.setVolume(0);
  ambiencePlayer.setLoopMode(LoopMode.all);
  ambiencePlayer.seek(Duration(milliseconds: position));

  Timer(Duration(milliseconds: countdown), () {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) {
      final percent = 1 - (event.remaining.inMilliseconds / kAmbienceFadeTime);
      ambiencePlayer.setVolume(percent * volume);
    });

    ambiencePlayer.positionStream.listen((event) {
      sendPort.send(ambiencePlayer.position.inMilliseconds);
    });
    ambiencePlayer.play();
  });

  /// Fade out and end ambience
  final timeToEnd = sessionTimeRemaining - kAmbienceFadeTime;

  Timer(Duration(milliseconds: timeToEnd), () {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) {
      final percent = (event.remaining.inMilliseconds / kAmbienceFadeTime);
      ambiencePlayer.setVolume(percent * volume);
    }).onDone(() {
      ambiencePlayer.stop();
    });
  });
}

class AmbienceServiceIsolate extends ConsumerStatefulWidget {
  const AmbienceServiceIsolate({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbienceServiceIsolate> createState() =>
      _AudioManagerWidgetState();
}

class _AudioManagerWidgetState extends ConsumerState<AmbienceServiceIsolate> {
  bool _ambienceHasStarted = false;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    /// Reset when [notStarted] state
    if (appState.sessionState == SessionState.notStarted) {
      _ambienceHasStarted = false;
      _stop();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        audioNotifier.setAmbiencePosition(0);
      });
    }

    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      if (!_ambienceHasStarted) {
        _ambienceHasStarted = true;
        _play(
          audioState: audioState,
          audioNotifier: audioNotifier,
          appState: appState,
          firstPlay: appState.elapsedTime == 0,
        );
      }
    }

    if (appState.sessionState == SessionState.paused) {
      _stop();
      _ambienceHasStarted = false;
    }

    return const SizedBox();
  }

  void _play({
    required AudioState audioState,
    required AudioNotifier audioNotifier,
    required AppState appState,
    required bool firstPlay,
  }) {
    /// Set total time
    int time = appState.time;
    if (appState.openSession) {
      time = kOpenSessionMaxTime;
    }

    final port = ReceivePort();
    List<dynamic> variables = [
      ///ambience
      audioState.ambience.name,

      ///volume
      audioState.ambienceVolume,

      ///start position
      audioState.ambiencePosition,

      ///countdown
      firstPlay ? appState.countdownTime : 0,

      /// time remaining
      firstPlay
          ? time + appState.countdownTime
          : time - (appState.elapsedTime - appState.countdownTime),

      /// port
      port.sendPort
    ];

    FlutterIsolate.spawn(playAmbience, variables);
    port.listen((position) {
      audioNotifier.setAmbiencePosition(position);
    });
  }

  void _stop() {
    FlutterIsolate.killAll();
  }
}
