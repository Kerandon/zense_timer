import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiver/async.dart';

import '../configs/constants.dart';
import '../enums/session_state.dart';
import '../state/app_state.dart';
import '../state/audio_state.dart';

class AmbienceServiceStandard extends ConsumerStatefulWidget {
  const AmbienceServiceStandard({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbienceServiceStandard> createState() =>
      _AmbienceServiceStandardState();
}

class _AmbienceServiceStandardState
    extends ConsumerState<AmbienceServiceStandard> {
  final _ambiencePlayer = AudioPlayer();
  bool _ambienceHasStarted = false;
  bool _ambienceHasResumed = true;

  @override
  Widget build(BuildContext context) {
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);

    /// Reset when [notStarted] state
    if (appState.sessionState == SessionState.notStarted) {
      _ambienceHasStarted = false;
      _stop();
    }

    if (appState.sessionState == SessionState.countdown ||
        appState.sessionState == SessionState.inProgress) {
      if (!_ambienceHasStarted) {
        _ambienceHasStarted = true;
        _playAmbience(audioState);
        _fadeOutAtEnd(appState, audioState);
      }
      if (!_ambienceHasResumed) {
        _ambienceHasResumed = true;
        _playAmbience(audioState, onStart: false);
        _fadeOutAtEnd(appState, audioState);
      }
    }

    if (appState.sessionState == SessionState.paused) {
      pause();
    }

    return const SizedBox.shrink();
  }

  Future<void> _playAmbience(AudioState audioState,
      {bool onStart = true}) async {
    if (onStart) {
      await _ambiencePlayer.seek(Duration.zero);
      await _ambiencePlayer.setLoopMode(LoopMode.all);
      await _ambiencePlayer
          .setAsset('assets/audio/ambience/${audioState.ambience.name}.mp3');
      CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
              const Duration(milliseconds: 1))
          .listen((event) async {
        final percent =
            1 - (event.remaining.inMilliseconds / kAmbienceFadeTime);
        await _ambiencePlayer.setVolume(percent * audioState.ambienceVolume);
      });
    }

    await _ambiencePlayer.play();
  }

  Future<void> _fadeOutAtEnd(AppState appState, AudioState audioState) async {
    int time = appState.time;
    if (appState.openSession) {
      time = kOpenSessionMaxTime;
    }

    final timeRemaining =
        time - (appState.elapsedTime + appState.countdownTime);

    /// Fade out and end ambience
    final timeToEndFadeStart = timeRemaining - kAmbienceFadeTime;

    Timer(Duration(milliseconds: timeToEndFadeStart), () {
      CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
              const Duration(milliseconds: 1))
          .listen((event) async {
        final percent = (event.remaining.inMilliseconds / kAmbienceFadeTime);
        _ambiencePlayer.setVolume(percent * audioState.ambienceVolume);
      }).onDone(() {
        _ambiencePlayer.stop();
      });
    });
  }

  Future<void> pause() async {
    await _ambiencePlayer.pause();
    _ambienceHasResumed = false;
    setState(() {});
  }

  Future<void> _stop() async {
    await _ambiencePlayer.stop();
  }
}
