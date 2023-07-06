import 'dart:async';
import 'dart:isolate';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiver/async.dart';
import 'package:zense_timer/utils/methods/audio_methods.dart';
import '../configs/constants.dart';
import '../enums/ambience.dart';
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

  if (ambience == kNone) {
    ambience = 'blank';
  }

  /// Countdown player to play 'white noise' if a countdown is set so the OS will next kill the app if backgrounded.
  final countdownPlayer = AudioPlayer();
  countdownPlayer
      .setAsset('assets/audio/ambience/blank.mp3')
      .then((value) async {
    await countdownPlayer.setVolume(0.01);
    await countdownPlayer.setLoopMode(LoopMode.all);
    countdownPlayer.play();
  });

  Timer(Duration(milliseconds: countdown + 6000), () {
    countdownPlayer.stop();
  });

  final ambiencePlayer = AudioPlayer();
  await ambiencePlayer.setAsset('assets/audio/ambience/$ambience.mp3');
  await ambiencePlayer.setVolume(0);
  await ambiencePlayer.setLoopMode(LoopMode.all);
  await ambiencePlayer.seek(Duration(milliseconds: position));

  Timer(Duration(milliseconds: countdown), () async {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) async {
      final percent = 1 - (event.remaining.inMilliseconds / kAmbienceFadeTime);
      if (ambience == kNone) {
        await ambiencePlayer.setVolume(0.01);
      } else {
        await ambiencePlayer.setVolume(percent * volume);
      }
    });

    ambiencePlayer.positionStream.listen((event) {
      sendPort.send(ambiencePlayer.position.inMilliseconds);
    });
    ambiencePlayer.play();
  });

  /// Fade out and end ambience
  int timeToEnd = sessionTimeRemaining - kAmbienceFadeTime;

  Timer(Duration(milliseconds: (timeToEnd + 3000)), () async {
    CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
            const Duration(milliseconds: 1))
        .listen((event) async {
      final percent = (event.remaining.inMilliseconds / kAmbienceFadeTime);
      await ambiencePlayer.setVolume(percent * volume);
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
  String ambienceSelected = Ambience.none.name;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioNotifier = ref.read(audioProvider.notifier);

    /// Reset when [notStarted] state
    if (appState.sessionState == SessionState.notStarted) {
      _stop();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        audioNotifier.setAmbiencePosition(0);
      });
    }

    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      ///Set Ambience
      String selectedAmbience = audioState.ambience.name;
      if (selectedAmbience == Ambience.shuffle.name) {
        selectedAmbience = getRandomAudio(getAllAmbienceToList());
      }

      if (!_ambienceHasStarted) {
        _ambienceHasStarted = true;
        bool isShuffle = false;
        if (audioState.ambience.name == Ambience.shuffle.name) {
          isShuffle = true;
        }

        bool firstPlay = true;
        if (appState.elapsedTime > 0) {
          firstPlay = false;
        }

        /// Set the ambience. Note is shuffle is on we want to randomly select. However,
        /// if shuffle is on but is RESUMED play, we want to continue the existing ambience already assigned.

        if (!isShuffle) {
          ambienceSelected = audioState.ambience.name;
        }
        if (isShuffle && firstPlay) {
          ambienceSelected = getRandomAudio(getAllAmbienceToList());
        }

        print('ambience selected is $ambienceSelected');

        _play(
          audioState: audioState,
          audioNotifier: audioNotifier,
          appState: appState,
          firstPlay: firstPlay,
          ambience: ambienceSelected,
        );
      }
    }

    if (appState.sessionState == SessionState.paused) {
      _stop();
    }

    if (appState.appWasStopped) {
      _stop();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setAppWasStopped(false);
      });
    }

    return const SizedBox();
  }

  void _play({
    required AudioState audioState,
    required AudioNotifier audioNotifier,
    required AppState appState,
    required bool firstPlay,
    required String ambience,
  }) {
    /// Set total time
    int time = appState.time;
    if (appState.openSession) {
      time = kOpenSessionMaxTime;
    }

    final port = ReceivePort();
    List<dynamic> variables = [
      ///ambience
      ambience,

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
    _ambienceHasStarted = false;
    FlutterIsolate.killAll();
  }
}
