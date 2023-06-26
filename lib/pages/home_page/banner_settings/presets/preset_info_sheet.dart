import 'package:zense_timer/app_components/info_sheet_dash.dart';
import 'package:zense_timer/pages/home_page/banner_settings/presets/preset_contents.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../models/prefs_model.dart';
import 'delete_preset_button.dart';

class PresetInfoSheet extends ConsumerWidget {
  const PresetInfoSheet({
    required this.preset,
    super.key,
  });

  final PrefsModel preset;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;

    final padding = size.width * 0.05;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, padding * 2),
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const InfoSheetDash(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Expanded(child: SizedBox()),
                    Expanded(
                      flex: 3,
                      child: Text(
                        'Preset - ${preset.name.toString()}',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Expanded(child: DeletePresetButton(preset: preset))
                  ],
                ),
                PresetContents(
                  preset: preset,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
