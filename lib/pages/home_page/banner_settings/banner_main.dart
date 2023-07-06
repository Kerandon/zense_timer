import 'package:animations/animations.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/ambience.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:zense_timer/models/stats_model.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../enums/interval_bell_type.dart';
import '../../../enums/time_period.dart';
import '../../../state/app_state.dart';
import '../../../state/audio_state.dart';
import '../../../state/database_service.dart';
import '../../../utils/methods/stats_methods.dart';
import '../../dashboard/dashboard_main.dart';
import 'bells/bell_info_sheet.dart';
import 'custom_home_button.dart';

class BannerMain extends ConsumerStatefulWidget {
  const BannerMain({
    super.key,
  });

  @override
  ConsumerState<BannerMain> createState() => _BannerMainState();
}

class _BannerMainState extends ConsumerState<BannerMain> {
  late final Future _allGroupedFuture;

  @override
  void initState() {
    _allGroupedFuture = DatabaseServiceAppData().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioState = ref.watch(audioProvider);
    final audioNotifier = ref.read(audioProvider.notifier);

    IconData bellIcon = FontAwesomeIcons.bellSlash;
    String bellTitle = kNone.capitalize();

    if (audioState.bellIntervalSound.name != kNone) {
      bellIcon = FontAwesomeIcons.bell;
      if (audioState.bellType == BellType.fixed) {
        bellTitle =
            'Fixed ${audioState.bellFixedTime.formatFromMilliseconds()}';
      } else {
        bellTitle =
            'Random ${audioState.bellRandom.min.formatFromMilliseconds()}-${audioState.bellRandom.max.formatFromMilliseconds()}';
      }
    } else {
      bellTitle = "";
      if (audioState.bellOnStartSound.name != kNone) {
        bellIcon = FontAwesomeIcons.bell;
        bellTitle = 'Start';
      }
      if (audioState.bellOnEndSound.name != kNone) {
        bellIcon = FontAwesomeIcons.bell;
        if (bellTitle != "") {
          bellTitle += ' & ';
        }
        bellTitle += 'End';
      }
    }

    final backgroundColor = Theme.of(context).colorScheme.surface;

    return Align(
      alignment: Alignment.bottomCenter,
      child: SizedBox(
          height: kToolbarHeight * 1.55,
          width: size.width,
          child: appState.sessionState == SessionState.notStarted
              ? IgnorePointer(
                  ignoring: appState.sessionState != SessionState.notStarted,
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(kBorderRadiusBig),
                        topRight: Radius.circular(kBorderRadiusBig),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(kBorderRadiusBig),
                          ),
                          child: CustomHomeButton(
                            title: bellTitle,
                            iconData: bellIcon,
                            onPressed: () {
                              audioNotifier.setBellSoundPageIsOpen(true);
                              showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) =>
                                          const BellInfoSheet())
                                  .then((value) async {
                                audioNotifier.setBellSoundPageIsOpen(false);
                              });
                            },
                          ),
                        ),
                        CustomHomeButton(
                          title: audioState.ambience.toText(),
                          iconData: audioState.ambience.toIcon(),
                          onPressed: () async {
                            audioNotifier
                                .setShowAmbience(!audioState.showAmbience);
                            appNotifier.setShowPresets(false);
                          },
                        ),
                        CustomHomeButton(
                            title: appState.selectedPreset == ""
                                ? kPresets
                                : appState.selectedPreset,
                            iconData: Icons.tune_outlined,
                            onPressed: () {
                              appNotifier.setShowPresets(
                                !appState.showPresets,
                              );
                              audioNotifier.setShowAmbience(false);
                            }),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(kBorderRadiusBig),
                          ),
                          child: SizedBox(
                            width: size.width / 4,
                            child: OpenContainer(
                              closedColor: backgroundColor,
                              openColor: backgroundColor,
                              openBuilder: (context, actions) =>
                                  const DashboardMain(),
                              closedBuilder: (context, actions) =>
                                  IgnorePointer(
                                ignoring: true,
                                child: FutureBuilder(
                                  future: _allGroupedFuture,
                                  builder: (context, snapshot) {
                                    List<StatsModel> stats = [];
                                    String currentStreakString = 'Dashboard';
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {}
                                    if (snapshot.hasData) {
                                      if (snapshot.data!.isNotEmpty) {
                                        stats = snapshot.data!;
                                        currentStreakString =
                                            'Streak: ${getCurrentStreak(stats).toString()}';
                                      }
                                    }
                                    return CustomHomeButton(
                                        title: currentStreakString,
                                        iconData: Icons.bar_chart_outlined,
                                        onPressed: () {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : const SizedBox()),
    );
  }
}
