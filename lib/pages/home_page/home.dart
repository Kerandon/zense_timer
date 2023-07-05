import 'package:zense_timer/pages/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../audio/ambience_service_isolate.dart';
import '../../audio/bell_service_isolate.dart';
import '../../configs/constants.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';
import '../../state/audio_state.dart';
import 'banner_settings/ambience/ambience_strip.dart';
import 'banner_settings/banner_main.dart';
import 'banner_settings/presets/presets_strip.dart';
import 'center_timer/timers/center_timer.dart';
import 'control_buttons/control_buttons.dart';
import 'countdown_message.dart';
import 'home_page_title.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  ConsumerState<HomePage> createState() => _HomePageContentsState();
}

class _HomePageContentsState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final audioState = ref.watch(audioProvider);
    const yStripAlign = -0.96;

    return Stack(
      children: [
        const BellServiceIsolate(),
        const AmbienceServiceIsolate(),
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          drawer: appState.sessionState == SessionState.notStarted
              ? const SettingsPage()
              : null,
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Theme.of(context).colorScheme.onBackground),
            backgroundColor: Theme.of(context).colorScheme.background,
            elevation: 0,
            title: const HomePageTitle(),
          ),
          body: Stack(
            children: [
              if (appState.colorTheme.name != kSimpleColorTheme) ...[
                Container(
                  width: size.width,
                  height: size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage(
                          'assets/images/background/${appState.colorTheme.name}.png'),
                    ),
                  ),
                  child: Container(
                    decoration:
                        BoxDecoration(color: Colors.white.withOpacity(0.0)),
                  ),
                ),
              ],
              if (appState.sessionState == SessionState.countdown) ...[
                const CountdownMessage()
              ],
              Align(
                alignment: const Alignment(0, -0.30),
                child: SizedBox(
                  width: size.width,
                  height: size.width,
                  child: const CenterTimer(),
                ),
              ),
              const BannerMain(),
              if (appState.showPresets &&
                  appState.sessionState == SessionState.notStarted) ...[
                const Align(
                  alignment: Alignment(0, yStripAlign),
                  child: PresetsStrip(),
                ),
              ],
              if (audioState.showAmbience &&
                  appState.sessionState == SessionState.notStarted) ...[
                const Align(
                  alignment: Alignment(0, yStripAlign),
                  child: AmbienceStrip(),
                ),
              ],
              const ControlButtons(),
            ],
          ),
        ),
      ],
    );
  }
}
