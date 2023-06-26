import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/time_period.dart';
import 'package:zense_timer/models/stats_model.dart';
import 'package:zense_timer/state/chart_state.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../animation/fade_in_animation.dart';
import '../../../app_components/custom_circular_progress.dart';
import '../../../state/database_service.dart';
import 'bar_touch_data.dart';

class BarChartMain extends ConsumerStatefulWidget {
  const BarChartMain({
    this.miniState = false,
    super.key,
  });

  final bool miniState;

  @override
  ConsumerState<BarChartMain> createState() => _BarChartHistoryState();
}

class _BarChartHistoryState extends ConsumerState<BarChartMain> {
  List<StatsModel> stats = [];

  bool _animate = false;
  bool _showLabels = false;
  bool _futureHasRun = false;
  Future<List<StatsModel>>? _statsFuture;

  @override
  Widget build(BuildContext context) {
    final chartState = ref.watch(chartStateProvider);

    if (_futureHasRun == false) {
      _statsFuture = DatabaseServiceAppData()
          .getStatsByTimePeriod(period: chartState.barChartTimePeriod);
      _futureHasRun = true;
    }

    return FutureBuilder<List<StatsModel>>(
      future: _statsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const FadeInAnimation(
              delayMilliseconds: 500,
              beginScale: 1,
              beginOpacity: 0,
              child: CustomLoadingIndicator());
        }

        List<BarChartGroupData> bars = [];
        if (snapshot.hasData) {
          if (!_animate) {
            _runAnimation();
          }
          bars = _getBarData(
                  snapshot.data!,
                  widget.miniState
                      ? TimePeriod.week
                      : chartState.barChartTimePeriod)
              .toList();
        }

        return Stack(
          children: [
            BarChart(
              BarChartData(
                barTouchData: getBarTouchData(showLabels: _showLabels),
                gridData: FlGridData(show: false),
                alignment: BarChartAlignment.spaceAround,
                borderData: borderData,
                barGroups: bars,
                titlesData: titlesData,
              ),
              swapAnimationDuration: const Duration(
                milliseconds: kFadeInTimeFast,
              ),
              swapAnimationCurve: Curves.easeOutQuint,
            ),
          ],
        );
      },
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    DateTime date = stats[value.toInt()].dateTime;
    final state = ref.watch(chartStateProvider);
    String formatted = 'EE';
    if (widget.miniState || state.barChartTimePeriod == TimePeriod.week) {
      formatted = DateFormat('EE').format(date);
    } else if (state.barChartTimePeriod == TimePeriod.fortnight) {
      formatted = DateFormat('d').format(date);
      var suffix = int.parse(formatted).addDateSuffix();
      formatted = '$formatted$suffix';
    } else if (state.barChartTimePeriod == TimePeriod.year) {
      formatted = DateFormat('MMM').format(date);
    } else if (state.barChartTimePeriod == TimePeriod.allTime) {
      formatted = DateFormat('y').format(date);
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        formatted,
        style: Theme.of(context).textTheme.displaySmall!.copyWith(
            fontSize: kChartLabelsFontSize,
            color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    ).animate().fadeIn();
  }

  get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
            sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: getTitles,
        )),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(
              color: Theme.of(context).colorScheme.onSurfaceVariant, width: 1),
        ),
      );

  List<BarChartGroupData> _getBarData(
      List<StatsModel> statsData, TimePeriod period) {
    stats.clear();
    Set<StatsModel> allTimePoints = {};
    DateTime now = DateTime.now();
    for (var s in statsData) {
      stats.add(s);
    }
    if (widget.miniState || period == TimePeriod.week) {
      for (int i = 0; i < 7; i++) {
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime(now.year, now.month, now.day - i),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.week,
          ),
        );
      }
    } else if (period == TimePeriod.fortnight) {
      for (int i = 0; i < 14; i++) {
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime(now.year, now.month, now.day - i),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.fortnight,
          ),
        );
      }
    } else if (period == TimePeriod.year) {
      for (int i = 0; i < 12; i++) {
        allTimePoints.add(
          StatsModel(
            dateTime: DateTime.now()
                .copyWith(month: DateTime.now().month - i, day: 01),
            totalMeditationTime: 0,
            timePeriod: TimePeriod.year,
          ),
        );
      }
    }
    final diff = allTimePoints.toSet().difference(stats.toSet()).toList();
    stats.addAll(diff);
    stats.sort((a, b) => a.dateTime.compareTo(b.dateTime));
    int allTimeIndex = -1;

    /// GET THE MAX Y VALUE AND ADD 20%
    double max = 0;
    if (stats.isNotEmpty) {
      max = _getMaxTime(max);
    } else {
      if (!widget.miniState && period == TimePeriod.allTime) {
        stats.add(StatsModel(dateTime: DateTime.now(), totalMeditationTime: 0));
      }
    }
    if (max == 0) {
      max = 1;
    }

    return stats.map(
      (e) {
        allTimeIndex++ - 1;
        return BarChartGroupData(
          x: !widget.miniState && period == TimePeriod.allTime
              ? allTimeIndex
              : stats.indexOf(e),
          barRods: [
            BarChartRodData(
                width: kChartBarLineWidth * 3,
                color: Theme.of(context).colorScheme.primary,
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: max,
                  color: Theme.of(context).colorScheme.shadow,
                ),
                toY: _animate ? e.totalMeditationTime.toDouble() : 0),
          ],
          showingTooltipIndicators: e.totalMeditationTime > 0 ? [0] : null,
        );
      },
    ).toList();
  }

  double _getMaxTime(double max) {
    List<StatsModel> tempList = stats.toList();
    tempList
        .sort((a, b) => a.totalMeditationTime.compareTo(b.totalMeditationTime));
    max = tempList.last.totalMeditationTime.toDouble() * 1.2;
    return max;
  }

  _runAnimation() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        _animate = true;

        setState(() {});
      }
    });
    Future.delayed(
      const Duration(
        milliseconds: kFadeInTimeFast ~/ 1.5,
      ),
      () {
        if (mounted) {
          _showLabels = true;

          setState(() {});
        }
      },
    );
  }
}
