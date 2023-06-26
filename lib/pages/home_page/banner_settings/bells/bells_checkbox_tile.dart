import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:zense_timer/configs/constants.dart';
import '../../../../enums/bell.dart';
import '../../../../enums/bell_stage.dart';
import '../../../../state/audio_state.dart';

class BellsCheckBoxTile extends ConsumerWidget {
  const BellsCheckBoxTile({
    super.key,
    required this.bell,
    required this.bellStage,
  });

  final Bell bell;
  final BellStage bellStage;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    final bool isSelected = bellStage == BellStage.start
        ? bell == audioState.bellOnStartSound
        : bellStage == BellStage.interval
            ? bell == audioState.bellIntervalSound
            : bell == audioState.bellOnEndSound;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: 1,
        maxWidth: size.width,
      ),
      child: CheckboxListTile(
          title: Padding(
            padding: EdgeInsets.only(left: size.width * 0.03),
            child: Text(bell.toText()),
          ),
          value: isSelected,
          onChanged: (value) async {
            switch (bellStage) {
              case BellStage.start:
                audioNotifier.setBellOnStartSound(bell);
                break;
              case BellStage.interval:
                audioNotifier.setIntervalBellSound(bell);
                break;
              case BellStage.end:
                audioNotifier.setBellOnEndSound(bell);
                break;
            }

            if (bell.name != kNone) {
              final player = AudioPlayer();
              await player
                  .setAsset('assets/audio/bells/${bell.name}.mp3')
                  .then((value) async {
                await player.setVolume(audioState.bellVolume);
                await player.play();
              });
            }
          }),
    );
  }
}
