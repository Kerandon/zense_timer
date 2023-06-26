import 'package:zense_timer/enums/ambience.dart';
import 'package:zense_timer/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../app_components/custom_strip_button.dart';
import '../../../../configs/constants.dart';
import 'ambience_info_sheet.dart';

class AmbienceStrip extends ConsumerStatefulWidget {
  const AmbienceStrip({Key? key}) : super(key: key);

  @override
  ConsumerState<AmbienceStrip> createState() => _AmbienceStripState();
}

class _AmbienceStripState extends ConsumerState<AmbienceStrip> {
  final Set<int> _hasAnimatedList = {};

  void _addToHasAnimated(int index) {
    if (mounted) {
      _hasAnimatedList.add(index);

      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        if (context.mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    return SizedBox(
      width: size.width,
      height: size.height * kHomePageStripHeight,
      child: ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          itemCount: Ambience.values.length,
          itemBuilder: (BuildContext context, int index) {
            final ambience = Ambience.values.firstWhere((element) =>
                element.name == Ambience.values.elementAt(index).name);
            bool isSelected = ambience.name == audioState.ambience.name;
            return CustomStripButton(
                showMusicIcon: true,
                infoSheetOpen: (open) {},
                index: index,
                duration: _hasAnimatedList.contains(index)
                    ? 0
                    : kStripAnimationDuration,
                hasAnimated: _addToHasAnimated,
                title: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: ambience.name == kNone ? size.width * 0.04 : 0,
                          right: size.width * 0.04),
                      child: Icon(
                        ambience.toIcon(),
                        color: isSelected
                            ? Colors.white
                            : Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    if (ambience.name != 'none') ...[
                      Text(
                        ambience.toText(),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: isSelected
                                ? Colors.white
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal),
                      ),
                    ],
                  ],
                ),
                onPressed: () async {
                  audioNotifier.setAmbience(ambience);
                },
                isSelected: isSelected,
                infoBar: ambience.name.toString() != 'none'
                    ? AmbienceInfoSheet(ambience: ambience)
                    : null);
          }),
    );
  }
}
