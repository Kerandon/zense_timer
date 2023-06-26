import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_switch_list_tile.dart';
import '../../../configs/themes/app_colors.dart';
import '../../../enums/app_color_themes.dart';
import '../../../state/app_state.dart';
import '../../../app_components/custom_animated_grid_box.dart';

class ColorTheme extends ConsumerWidget {
  const ColorTheme({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Theme'),
      ),
      body: Padding(
        padding:
            EdgeInsets.symmetric(horizontal: size.width * kPageIndentation),
        child: SingleChildScrollView(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              CustomSwitchListTile(
                  topPadding: true,
                  title: 'Follow OS setting',
                  icon: Icons.settings_outlined,
                  value: appState.followOSTheme,
                  onChanged: (value) => appNotifier.setFollowOSTheme(value)),
              CustomSwitchListTile(
                bottomPadding: true,
                title: 'Dark mode',
                icon: Icons.dark_mode_outlined,
                value: appState.darkTheme,
                onChanged: (value) => appNotifier.setDarkTheme(value),
                disable: appState.followOSTheme,
              ),
              GridView.builder(
                itemCount: AppColorTheme.values.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemBuilder: (context, index) {
                  final colorTheme = AppColorTheme.values.elementAt(index);
                  return CustomAnimatedGridBox(
                    labelText: colorTheme.name,
                    onPressed: () async =>
                        appNotifier.setColorTheme(colorTheme),
                    isSelected: colorTheme == appState.colorTheme,
                    contents: Container(
                      decoration: BoxDecoration(
                        color: appState.darkTheme
                            ? AppColors.surfaceDarkTheme
                            : AppColors.shadowLightTheme,
                        borderRadius: BorderRadius.circular(kBorderRadiusBig),
                        image: colorTheme.name == kSimpleColorTheme
                            ? null
                            : DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                    'assets/images/background/${colorTheme.name}.png')),
                      ),
                    ).animate().fadeIn(duration: 3.seconds),
                    selectedLabelColor: Theme.of(context).canvasColor,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
