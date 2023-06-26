import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:zense_timer/pages/dashboard/dashboard_main.dart';
import 'package:zense_timer/pages/home_page/banner_settings/presets/add_preset_dialog.dart';
import 'package:zense_timer/pages/home_page/home.dart';
import 'package:zense_timer/state/audio_state.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../enums/time_period.dart';
import '../../models/stats_model.dart';
import '../../state/app_state.dart';
import '../../state/database_service.dart';
import '../../utils/methods/stats_methods.dart';
import 'completion_quotes.dart';
import 'completion_stat_box.dart';

class CompletionPage extends ConsumerStatefulWidget {
  const CompletionPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CompletionPage> createState() => _CompletionPageState();
}

class _CompletionPageState extends ConsumerState<CompletionPage> {
  late final Future<List<StatsModel>> _allGroupedFuture;
  late final Future<StatsModel> _lastEntryFuture;
  bool _notifiedSessionChange = false;

  @override
  void initState() {
    _allGroupedFuture = DatabaseServiceAppData().getStatsByTimePeriod(
        allTimeGroupedByDay: true, period: TimePeriod.allTime);
    _lastEntryFuture = DatabaseServiceAppData().getLastEntry();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    final appNotifier = ref.read(appProvider.notifier);
    final audioNotifier = ref.read(audioProvider.notifier);
    _onSessionEnd(appNotifier, appState);

    String totalTime = "";

    return WillPopScope(
      onWillPop: () {
        return _goHome(appNotifier, context);
      },
      child: Scaffold(
        body: FutureBuilder<dynamic>(
          future: Future.wait([_allGroupedFuture, _lastEntryFuture]),
          builder: (context, snapshot) {
            String currentStreakString = '0';
            if (snapshot.hasData) {
              if (snapshot.data!.isNotEmpty) {
                List<StatsModel> stats = snapshot.data![0];
                currentStreakString = getCurrentStreak(stats).toString();
                StatsModel lastEntry = snapshot.data![1];
                totalTime =
                    (lastEntry.totalMeditationTime).formatFromMilliseconds();
              }
              return Padding(
                padding: EdgeInsets.all(size.width * 0.05),
                child: SizedBox(
                  height: size.height,
                  width: size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            'Congratulations\nSession Completed',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width,
                        height: size.height * 0.25,
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(size.width * 0.05),
                            child: Shimmer.fromColors(
                              baseColor: Theme.of(context).colorScheme.primary,
                              highlightColor:
                                  Theme.of(context).colorScheme.secondary,
                              delay: const Duration(seconds: 6),
                              child: Image.asset(
                                'assets/images/meditation_woman.png',
                              ),
                            ),
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 1.seconds)
                            .scaleXY(begin: 0.95),
                      ),
                      const CompletionQuotes(),
                      SizedBox(
                        height: size.height * 0.20,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height * 0.015),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: CompletionStatBox(
                                  text: 'Time',
                                  value: totalTime,
                                  onTap: () {
                                    _pushStats(context, appNotifier);
                                  },
                                ),
                              ),
                              Expanded(
                                child: CompletionStatBox(
                                  text: 'Streak',
                                  value: currentStreakString,
                                  onTap: () {
                                    _pushStats(context, appNotifier);
                                  },
                                ),
                              ),
                              Expanded(
                                child: CompletionStatBox(
                                  text: 'Save current\nsetting as preset',
                                  icon: Icons.add,
                                  onTap: () {
                                    final dialog = showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const AddPresetDialog());
                                    dialog.then(
                                      (value) async {
                                        audioNotifier.setShowAmbience(false);
                                        appNotifier.setShowPresets(true);
                                        appNotifier.setSessionState(
                                          SessionState.notStarted,
                                        );
                                        await Navigator.of(context)
                                            .pushAndRemoveUntil(
                                                PageRouteBuilder(
                                                  pageBuilder: (_, __, ___) =>
                                                      const HomePage(),
                                                ),
                                                (route) => false);
                                      },
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        width: size.width * kButtonWidth,
                        height: size.height * 0.15,
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: size.height * 0.03),
                          child: IconButton(
                            icon: Icon(
                              Icons.refresh_outlined,
                              size: 50,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            onPressed: () {
                              _goHome(appNotifier, context);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Future<bool> _goHome(AppNotifier appNotifier, BuildContext context) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      appNotifier.setSessionState(
        SessionState.notStarted,
      );
      await Navigator.of(context).pushAndRemoveUntil(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const HomePage(),
          ),
          (route) => false);
    });
    return true;
  }

  void _onSessionEnd(AppNotifier appNotifier, AppState appState) {
    if (!_notifiedSessionChange) {
      _notifiedSessionChange = true;
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        appNotifier.setSessionState(SessionState.ended);
      });
    }
  }

  void _pushStats(BuildContext context, AppNotifier notifier) async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      notifier.setSessionState(SessionState.notStarted);
    });
    await Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const DashboardMain(),
        ),
        (route) => false);
  }
}
