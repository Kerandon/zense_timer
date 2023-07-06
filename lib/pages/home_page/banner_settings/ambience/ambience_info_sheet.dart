import 'dart:async';
import 'package:animated_music_indicator/animated_music_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quiver/async.dart';
import 'package:zense_timer/utils/methods/audio_methods.dart';
import '../../../../app_components/info_sheet_dash.dart';
import '../../../../configs/constants.dart';
import '../../../../enums/ambience.dart';
import '../../../../state/audio_state.dart';
import 'ambience_volume_slider.dart';

class AmbienceInfoSheet extends ConsumerStatefulWidget {
  const AmbienceInfoSheet({Key? key, required this.ambience}) : super(key: key);

  final Ambience ambience;

  @override
  ConsumerState<AmbienceInfoSheet> createState() => _AmbienceInfoSheetState();
}

class _AmbienceInfoSheetState extends ConsumerState<AmbienceInfoSheet> {
  bool _ambienceHasPlayedOnInit = false;
  late final AudioPlayer _player;
  double _volume = 0;
  CountdownTimer? _timer;

  @override
  void initState() {
    _player = AudioPlayer();
    super.initState();
  }

  @override
  void dispose() {
    _stop(
      startVolume: _volume,
    );
    Future.delayed(const Duration(seconds: 3), () {
      _player.dispose();
      _timer?.cancel();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = size.width * 0.05;
    final audioState = ref.watch(audioProvider);

    _volume = audioState.ambienceVolume;
    _player.setVolume(_volume);
    _playAudio();
    bool isShuffle = widget.ambience.name == Ambience.shuffle.name;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding * 2),
      child: SizedBox(
        height: size.height * 0.60,
        child: Column(
          children: [
            const InfoSheetDash(),
            Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: const AmbienceVolumeSlider(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: size.width * 0.04),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.all(size.width * 0.05),
                    child: Icon(widget.ambience.toIcon()),
                  ),
                  Text(widget.ambience.toText()),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: size.height * 0.35,
                      width: size.width * 0.80,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.tertiary,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                              Theme.of(context).colorScheme.primary,
                              BlendMode.difference),
                          fit: isShuffle ? BoxFit.scaleDown : BoxFit.cover,
                          image: AssetImage(
                              'assets/images/ambience/${widget.ambience.name}.png'),
                        ),
                        borderRadius: BorderRadius.circular(kBorderRadiusBig),
                        border: Border.all(
                          color: Theme.of(context).splashColor,
                        ),
                      ),
                    ),
                  ),
                  const Align(
                    alignment: Alignment(0.60, 0.80),
                    child: AnimatedMusicIndicator(
                      size: 0.20,
                      barStyle: BarStyle.dash,
                      color: Color.fromARGB(255, 240, 230, 220),
                    ),
                  )
                ],
              ).animate().fadeIn(duration: 2.seconds).scaleXY(begin: 0.95),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playAudio() async {
    if (!_ambienceHasPlayedOnInit) {
      _ambienceHasPlayedOnInit = true;
      String ambience = widget.ambience.name;
      if (ambience == Ambience.shuffle.name) {
        ambience = getRandomAudio(getAllAmbienceToList());
      }

      await _player
          .setAsset('assets/audio/ambience/$ambience.mp3')
          .then((value) async {
        await _player.play();
      });
    }
  }

  Future<void> _stop({double? startVolume}) async {
    if (_player.playing) {
      _timer = CountdownTimer(const Duration(milliseconds: kAmbienceFadeTime),
          const Duration(milliseconds: 1))
        ..listen((event) {
          final percent = event.remaining.inMilliseconds / kAmbienceFadeTime;

          if (_player.playing) {
            _player.setVolume(percent * startVolume!);
          }
        }).onDone(() async {
          await _player.stop();
        });
    }
  }
}
