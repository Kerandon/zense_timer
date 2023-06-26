import 'package:zense_timer/pages/dashboard/bar_chart/headline_total_time.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../configs/constants.dart';
import '../../../state/chart_state.dart';
import 'bar_chart_main.dart';
import 'bar_chart_toggle_buttons.dart';

class BarChartTile extends ConsumerStatefulWidget {
  const BarChartTile({
    required this.isDisabled,
    super.key,
  });

  final bool isDisabled;

  @override
  ConsumerState<BarChartTile> createState() => _ChartsClosedState();
}

class _ChartsClosedState extends ConsumerState<BarChartTile> {
  bool _toggle = false;

  void _toggleHistoryChart() {
    setState(() {
      _toggle = !_toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final chartNotifier = ref.read(chartStateProvider.notifier);
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(kBorderRadiusBig)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: size.height * (kPageIndentation / 2)),
            child: const HeadlineTotalTime(),
          ),
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.height * (kPageIndentation / 2)),
                child: SizedBox(
                    height: size.height * 0.22,
                    child: _toggle
                        ? const BarChartMain(key: ValueKey(0))
                        : const BarChartMain(key: ValueKey(1))),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    vertical: size.height * (kPageIndentation / 2)),
                child: BarChartToggleButtons(
                  disable: widget.isDisabled,
                  toggled: () {
                    _toggleHistoryChart.call();
                    chartNotifier.setBarChartToggle(true);
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        chartNotifier.setBarChartToggle(false);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
