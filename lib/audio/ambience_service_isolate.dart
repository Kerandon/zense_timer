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
Future<void> playAmbience(dynamic args) async {
  String ambience = args[0];
  double volume = args[1];
  int position = args[2];
  int countdown = args[3];
  int sessionTimeRemaining = args[4];
  SendPort sendPort = args[5];

  final ambiencePlayer = AudioPlayer();
  await ambiencePlayer.setAsset('assets/audio/ambience/$ambience.mp3');
  ambiencePlayer.seek(Duration(milliseconds: position));
  await ambiencePlayer.setVolume(0);
  await ambiencePlayer.setLoopMode(LoopMode.all);

  Timer(Duration(milliseconds: countdown), () async {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) async {
      final percent = 1 - (event.remaining.inMilliseconds / kAmbienceFadeTime);

      ambiencePlayer.setVolume(percent * volume);
    });

    ambiencePlayer.positionStream.listen((event) {
      sendPort.send(ambiencePlayer.position.inMilliseconds);
    });
    await ambiencePlayer.play();
  });

  /// Fade out and end ambience
  final timeToEnd = (sessionTimeRemaining + countdown) - kAmbienceFadeTime;

  Timer(Duration(milliseconds: timeToEnd), () {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) async {
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
  bool _ambienceHasResumed = true;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    /// Reset when [notStarted] state
    if (appState.sessionState == SessionState.notStarted) {
      _ambienceHasStarted = false;
      _ambienceHasResumed = true;
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
          firstPlay: true,
        );
      }
      if (!_ambienceHasResumed && audioState.ambiencePosition > 0) {
        _ambienceHasResumed = true;
        _play(
          audioState: audioState,
          audioNotifier: audioNotifier,
          appState: appState,
          firstPlay: false,
        );
      }
    }

    if (appState.sessionState == SessionState.paused) {
      _stop();
      _ambienceHasResumed = false;
    }

    return const SizedBox();
  }

  Future<void> _play({
    required AudioState audioState,
    required AudioNotifier audioNotifier,
    required AppState appState,
    required bool firstPlay,
  }) async {
    /// Set total time
    int time = appState.time;
    if (appState.openSession) {
      time = kOpenSessionMaxTime;
    }

    final port = ReceivePort();
    List<dynamic> msg = [
      audioState.ambience.name,
      audioState.ambienceVolume,
      audioState.ambiencePosition,
      firstPlay ? appState.countdownTime : 0,
      firstPlay ? time : time - appState.elapsedTime,
      port.sendPort
    ];

    await FlutterIsolate.spawn(playAmbience, msg);
    port.listen((position) {
      audioNotifier.setAmbiencePosition(position);
    });
  }

  Future<void> _stop() async {
    await FlutterIsolate.killAll();
  }
}
