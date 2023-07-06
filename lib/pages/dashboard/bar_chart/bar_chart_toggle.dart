import 'package:zense_timer/animation/fade_in_animation.dart';
import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/state/chart_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../app_components/custom_button.dart';
import '../../../enums/time_period.dart';

class BarChartToggle extends ConsumerWidget {
  const BarChartToggle({
    Key? key,
    required this.timePeriod,
    required this.toggledCallback,
    required this.disable,
  }) : super(key: key);
  final TimePeriod timePeriod;
  final VoidCallback toggledCallback;
  final bool disable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(chartStateProvider);
    final notifier = ref.read(chartStateProvider.notifier);
    final isSelected = state.barChartTimePeriod == timePeriod;

    return FadeInAnimation(
      animateOnDemand: state.toggleBarChart,
      delayMilliseconds: kFadeInDelay,
      child: CustomButton(
        fontSize: 11,
        disable: disable,
        minButtonWidth: 0.19,
        isSelected: isSelected,
        onPressed: disable
            ? null
            : () {
                toggledCallback.call();
                notifier.setBarChartTimePeriod(timePeriod);
              },
        text: timePeriod.toText(),
      ),
    );
  }
}
