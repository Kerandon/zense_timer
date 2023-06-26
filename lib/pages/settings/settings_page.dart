import 'package:zense_timer/enums/platform.dart';
import 'package:zense_timer/main.dart';
import 'package:zense_timer/pages/settings/reset/reset_dialog.dart';
import 'package:zense_timer/pages/settings/timer_design/timer_design_page.dart';
import 'package:zense_timer/pages/settings/vibrate/vibrate_page.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'about/about_dialog.dart';
import 'color_theme/color_theme_page.dart';
import 'dnd/mute_device_page.dart';
import 'faq/faq_page.dart';
import 'guide_page/guide_page.dart';
import 'components/settings_divider.dart';
import '../../app_components/custom_settings_tile.dart';
import 'countdown/countdown_page.dart';
import 'keep_awake/keep_awake.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    return Drawer(
      width: size.width,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            const SettingsTitleDivider(
              title: 'MORE SETUP OPTIONS',
              hideDivider: true,
            ),
            CustomSettingsTile(
              icon: const Icon(
                Icons.timer_outlined,
              ),
              title: 'Warmup countdown',
              subTitle: state.countdownTime > 0
                  ? state.countdownTime.formatFromMilliseconds()
                  : 'None',
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CountdownPage()));
              },
            ),
            const VibratePage(),
            // if (platform == AppPlatform.android) ...[const DNDPage()],
            const KeepAwakePage(),
            const SettingsTitleDivider(
              title: 'APP THEME',
            ),
            CustomSettingsTile(
              icon: const Icon(
                Icons.color_lens_outlined,
              ),
              title: 'App theme',
              subTitle: state.colorTheme.name.capitalize(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const ColorTheme(),
                  ),
                );
              },
            ),
            CustomSettingsTile(
              icon: const Icon(FontAwesomeIcons.clock),
              title: 'Timer face',
              subTitle: state.timerDesign.name.capitalize(),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const TimerFacePage(),
                  ),
                );
              },
            ),
            const SettingsTitleDivider(),
            CustomSettingsTile(
                title: 'Guidance',
                onPressed: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GuidePage()));
                },
                icon: const Icon(Icons.tips_and_updates_outlined)),
            const SettingsTitleDivider(
              title: 'ABOUT',
            ),
            CustomSettingsTile(
                icon: const Icon(Icons.info_outline),
                title: 'About app',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const CustomAboutDialog());
                }),
            CustomSettingsTile(
                icon: const Icon(Icons.question_answer_outlined),
                title: 'FAQs',
                onPressed: () async {
                  await Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const FAQPage()));
                }),
            const SettingsTitleDivider(),
            CustomSettingsTile(
                icon: const Icon(
                  Icons.restart_alt_outlined,
                ),
                title: 'Reset',
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const ResetDialog());
                }),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.15,
                bottom: size.height * 0.05,
              ),
              child: Center(
                child: Text('© 2023 Zenbition Limited 9429048108997',
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                        fontSize: 9,
                        color: Theme.of(context).colorScheme.onSurfaceVariant)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
