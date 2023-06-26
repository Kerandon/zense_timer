import 'dart:async';
import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/pages/dashboard/stats_components/stats_tile_shell.dart';
import 'package:zense_timer/pages/dashboard/average_time/headline_average.dart';
import 'package:zense_timer/pages/dashboard/usual_time_chart/time_stats.dart';
import 'package:zense_timer/pages/dashboard/stats_history/stats_history_page.dart';
import 'package:zense_timer/pages/dashboard/streak/streak_closed.dart';
import 'package:zense_timer/pages/dashboard/streak/streak_open.dart';
import 'package:zense_timer/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../app_components/custom_popup.dart';
import '../../models/stats_model.dart';
import '../../state/database_service.dart';
import '../home_page/home.dart';
import 'bar_chart/bar_chart_tile.dart';
import 'last_meditation/last_meditation_tile.dart';

class DashboardMain extends ConsumerStatefulWidget {
  const DashboardMain({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardMain> createState() => _DashboardMainState();
}

class _DashboardMainState extends ConsumerState<DashboardMain> {
  late final Future<List<StatsModel>> _allStatsFuture;

  @override
  void initState() {
    _allStatsFuture = DatabaseServiceAppData().getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartState = ref.watch(chartStateProvider);
    final chartNotifier = ref.read(chartStateProvider.notifier);
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            PageRouteBuilder(pageBuilder: (_, __, ___) => const HomePage()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    PageRouteBuilder(
                        pageBuilder: (_, __, ___) => const HomePage()),
                    (route) => false);
              },
              icon: const Icon(Icons.arrow_back_outlined)),
          title: const Text('Dashboard'),
          actions: [
            Padding(
                padding: EdgeInsets.fromLTRB(size.width * 0.01,
                    size.width * 0.01, size.width * 0.05, size.width * 0.01),
                child: IconButton(
                    onPressed: chartState.haveData
                        ? () => Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const StatsHistoryPage()))
                        : null,
                    icon: const Icon(Icons.edit_outlined)))
          ],
        ),
        body: FutureBuilder(
          future: _allStatsFuture,
          builder: (context, snapshot) {
            List<StatsModel> stats = [];
            if (snapshot.hasData) {
              stats.addAll(snapshot.data!);
              if (stats.isEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  chartNotifier.setHaveData(false);
                });
              } else {
                WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                  chartNotifier.setHaveData(true);
                });
              }
            }

            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * kPageIndentation),
                  child: Center(
                    child: SizedBox(
                      width: size.width,
                      height: size.height,
                      child: GridView.custom(
                        gridDelegate: SliverStairedGridDelegate(
                          startCrossAxisDirectionReversed: true,
                          pattern: [
                            const StairedGridTile(0.50, 1.0),
                            const StairedGridTile(0.50, 1.0),
                            const StairedGridTile(1, 0.9),
                            const StairedGridTile(1, 3),
                            const StairedGridTile(1, 1),
                          ],
                        ),
                        childrenDelegate: SliverChildBuilderDelegate(
                          childCount: 5,
                          (context, index) {
                            switch (index) {
                              case 0:
                                return const StatsTileShell(
                                  closedContents: LastMeditationTile(),
                                );
                              case 1:
                                return StatsTileShell(
                                  closedContents: const StreakClosed(),
                                  openContents: chartState.haveData
                                      ? const StreakOpen()
                                      : null,
                                );
                              case 2:
                                return StatsTileShell(
                                  closedContents: BarChartTile(
                                    isDisabled: snapshot.data?.isEmpty ?? true,
                                  ),
                                );
                              case 3:
                                return const StatsTileShell(
                                  closedContents: AverageTime(),
                                );
                              case 4:
                                return const StatsTileShell(
                                  closedContents: TimeStats(),
                                );
                            }
                            return Container();
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                if (!chartState.haveData) ...[
                  const CustomPopupBox(
                    text: 'No data yet to display',
                  )
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}
