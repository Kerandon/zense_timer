import 'package:zense_timer/app_components/custom_button.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/models/prefs_model.dart';
import 'package:zense_timer/pages/home_page/banner_settings/presets/preset_contents.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:zense_timer/state/audio_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../state/database_service.dart';

class AddPresetDialog extends ConsumerStatefulWidget {
  const AddPresetDialog({
    super.key,
  });

  @override
  ConsumerState<AddPresetDialog> createState() => _AddPresetDialogState();
}

class _AddPresetDialogState extends ConsumerState<AddPresetDialog> {
  final _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final size = media.size;
    final insets = media.viewInsets.bottom;
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);

    return AlertDialog(
        insetPadding: EdgeInsets.all(size.width * 0.10),
        content: SizedBox(
          width: size.width,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Create a new custom preset',
                  style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: size.height * 0.03),
                  child: Form(
                    key: _formKey,
                    child: SizedBox(
                      width: size.width * 0.70,
                      child: TextFormField(
                        controller: _textEditingController,
                        validator: (value) {
                          if (value == null ||
                              value.isEmpty ||
                              value.trim().isEmpty) {
                            return 'Present name is not set';
                          }
                          return null;
                        },
                        cursorColor: Theme.of(context).primaryColor,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 22),
                        maxLength: 20,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(kBorderRadiusBig * 2),
                            ),
                            contentPadding: EdgeInsets.all(size.height * 0.020),
                            counterText: "",
                            labelText: '     Preset name',
                            labelStyle: Theme.of(context).textTheme.bodyLarge),
                      ),
                    ),
                  ),
                ),
                if (insets == 0) ...[
                  PresetContents(
                    preset:
                        buildCurrentPrefsModel('name', appState, audioState),
                  )
                ],
                if (insets > 0) ...[
                  IconButton(
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(Icons.expand_less),
                  )
                ]
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          CustomButton(
              setToBackgroundColor: true,
              text: 'Save',
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final name = _textEditingController.value.text.trim();

                  DatabaseServiceAppData()
                      .insertIntoPresets(
                          presetModel: buildCurrentPrefsModel(
                              name, appState, audioState))
                      .then((value) async {
                    await Navigator.of(context).maybePop();
                  });
                }
              }),
          CustomButton(
            setToBackgroundColor: true,
            text: 'Close',
            onPressed: () async => await Navigator.of(context).maybePop(),
          )
        ]);
  }

  PrefsModel buildCurrentPrefsModel(
      String name, AppState appState, AudioState audioState) {
    return PrefsModel(
      name: name,
      openSession: appState.openSession,
      time: appState.time,
      countdownTime: appState.countdownTime,
      bellVolume: audioState.bellVolume,
      bellOnStartSound: audioState.bellOnStartSound,
      bellIntervalSound: audioState.bellIntervalSound,
      bellOnEndSound: audioState.bellOnEndSound,
      bellType: audioState.bellType,
      bellFixedTime: audioState.bellFixedTime,
      bellRandom: audioState.bellRandom,
      ambience: audioState.ambience,
      ambienceVolume: audioState.ambienceVolume,
      colorTheme: appState.colorTheme,
      followOSTheme: appState.followOSTheme,
      darkTheme: appState.darkTheme,
      showTimer: appState.showTimer,
      timerDesign: appState.timerDesign,
      reverseTimer: appState.reverseTimer,
      showClock: appState.showClock,
      vibrate: appState.vibrate,
    );
  }
}
