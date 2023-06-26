import 'package:zense_timer/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../enums/prefs.dart';
import '../../../../state/database_service.dart';

class AmbienceVolumeSlider extends ConsumerWidget {
  const AmbienceVolumeSlider({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: size.width * 0.03,
          ),
        ),
        const Icon(Icons.audiotrack_outlined),
        Padding(
          padding: EdgeInsets.all(size.width * 0.03),
          child: Text(
            (audioState.ambienceVolume * 10).round().toString(),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          flex: 18,
          child: Slider(
            inactiveColor: Theme.of(context).colorScheme.shadow,
            value: audioState.ambienceVolume,
            onChanged: (value) async {
              double volume = value;
              audioNotifier.setAmbienceVolume(volume);
              await DatabaseServiceAppData()
                  .insertIntoPrefs(k: Prefs.ambienceVolume.name, v: value);
            },
            min: 0.1,
            max: 1.0,
          ),
        ),
      ],
    );
  }
}
