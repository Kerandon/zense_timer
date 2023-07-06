import 'package:zense_timer/pages/home_page/banner_settings/presets/preset_info_sheet.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../app_components/custom_strip_button.dart';
import '../../../../configs/constants.dart';
import '../../../../models/prefs_model.dart';
import '../../../../state/audio_state.dart';
import '../../../../state/database_service.dart';
import 'add_preset_dialog.dart';

class PresetsStrip extends ConsumerStatefulWidget {
  const PresetsStrip({
    super.key,
  });

  @override
  ConsumerState<PresetsStrip> createState() => _PresetsStripState();
}

class _PresetsStripState extends ConsumerState<PresetsStrip> {
  bool _presetsClearedOnInit = false;

  final Set<int> _hasAnimatedList = {};

  void _addToHasAnimated(int index) {
    _hasAnimatedList.add(index);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioNotifier = ref.read(audioProvider.notifier);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (!_presetsClearedOnInit) {
        appNotifier.setSelectedPreset("");
        _presetsClearedOnInit = true;
      }
    });
    return FutureBuilder<List<PrefsModel>>(
      future: DatabaseServiceAppData().getPresets(),
      builder: (context, snapshot) {
        List<PrefsModel> presets = [];

        if (snapshot.hasData) {
          presets = snapshot.data!.toList();

          presets.sort((a, b) => a.name!.compareTo(b.name!));

          bool isSelected = false;
          return SizedBox(
            width: size.width,
            height: size.height * kHomePageStripHeight,
            child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: presets.length + 1,
                itemBuilder: (BuildContext context, int index) {
                  if (index == presets.length) {
                    return CustomStripButton(
                      index: index,
                      title: SizedBox(
                          width: size.width * 0.18,
                          child: Icon(
                            Icons.add,
                            color: Theme.of(context).colorScheme.onBackground,
                            size: 30,
                          )),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) => const AddPresetDialog());
                      },
                      duration: _hasAnimatedList.contains(index)
                          ? 0
                          : kStripAnimationDuration,
                      hasAnimated: _addToHasAnimated,
                    );
                  } else {
                    final preset = presets[index];
                    isSelected = appState.selectedPreset ==
                        presets[index].name.toString();

                    return CustomStripButton(
                      index: index,
                      title: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * kStripPadding),
                        child: Text(
                          preset.name.toString(),
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? Colors.white
                                      : Theme.of(context)
                                          .colorScheme
                                          .onBackground),
                        ),
                      ),
                      onPressed: () async {
                        appNotifier.setSelectedPreset(preset.name.toString());
                        appNotifier.setAllPrefs(
                          prefsModel: preset,
                        );
                        audioNotifier.setAllPrefs(preset);
                        await DatabaseServiceAppData()
                            .insertAllIntoPrefs(prefs: preset);
                      },
                      isSelected: isSelected,
                      infoBar: PresetInfoSheet(
                        preset: presets[index],
                      ),
                    );
                  }
                }),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
