import 'package:zense_timer/pages/dashboard/dashboard_main.dart';
import 'package:zense_timer/pages/dashboard/stats_history/select_buttons.dart';
import 'package:zense_timer/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../models/stats_model.dart';
import '../../../state/database_service.dart';
import 'stats_event_tile.dart';

class StatsHistoryPage extends ConsumerStatefulWidget {
  const StatsHistoryPage({
    super.key,
  });

  @override
  ConsumerState<StatsHistoryPage> createState() => _AllMeditationsListState();
}

class _AllMeditationsListState extends ConsumerState<StatsHistoryPage> {
  late final Future<List<StatsModel>> _allMeditationFuture;

  /// Clears selected meditation events on [initState]
  bool _meditationEventsClearedOnInit = false;

  @override
  void initState() {
    _allMeditationFuture = DatabaseServiceAppData().getAllStats();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartNotifier = ref.read(chartStateProvider.notifier);
    String timeText = "";
    if (!_meditationEventsClearedOnInit) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        chartNotifier.clearAllMeditationEvents();
      });
      _meditationEventsClearedOnInit = true;
    }

    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const DashboardMain()),
            (route) => false);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) => const DashboardMain()),
                  (route) => false);
            },
            icon: const Icon(
              Icons.arrow_back_outlined,
            ),
          ),
          title: const Text('Meditation history'),
        ),
        body: FutureBuilder(
            future: _allMeditationFuture,
            builder: (context, snapshot) {
              List<StatsModel> stats = [];

              if (snapshot.hasData) {
                if (snapshot.data!.isNotEmpty) {
                  stats.addAll(snapshot.data!);
                  stats = stats.reversed.toList();
                }

                if (stats.length == 1) {
                  timeText = ' time';
                } else {
                  timeText = ' times';
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: size.height * 0.03),
                      child: RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge!,
                          text: 'You have meditated ',
                          children: [
                            TextSpan(
                              text: stats.length.toString(),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            TextSpan(
                              text: timeText,
                            ),
                          ],
                        ),
                      ),
                    ),
                    if (stats.isNotEmpty) ...[
                      SelectButtons(
                        stats: stats,
                      ),
                    ],
                    ListView.builder(
                      itemCount: stats.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) => StatsEventTile(
                        stat: stats[index],
                        index: index,
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
