import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:numberpicker/numberpicker.dart';
import '../../../../../configs/constants.dart';
import '../../../../../state/app_state.dart';

class CustomNumberPicker extends ConsumerWidget {
  const CustomNumberPicker({
    super.key,
    required this.alignment,
    required this.text,
  });

  final MainAxisAlignment alignment;
  final String text;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final state = ref.watch(appProvider);
    final notifier = ref.read(appProvider.notifier);
    final minuteValue = (state.time % 3600000) ~/ 60000;
    final hourValue = state.time ~/ 3600000;

    return Expanded(
      child: Row(
        mainAxisAlignment: alignment,
        children: [
          NumberPicker(
            textStyle: Theme.of(context).textTheme.displaySmall!.copyWith(
                fontSize: 15,
                color: Theme.of(context)
                    .colorScheme
                    .onSurfaceVariant
                    .withOpacity(0.80)),
            selectedTextStyle: Theme.of(context)
                .textTheme
                .displaySmall!
                .copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onBackground),
            itemWidth: size.width * 0.15,
            itemHeight: size.height * 0.06,
            minValue: 0,
            maxValue: text == 'M' ? 59 : 23,
            value: text == 'M' ? minuteValue : hourValue,
            onChanged: (int value) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                if (text == 'M') {
                  notifier.setTime(minutes: value, hours: hourValue);
                } else {
                  notifier.setTime(minutes: minuteValue, hours: value);
                }
              });
            },
          ),
          Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    ).animate().fadeIn(duration: kFadeInTimeFast.milliseconds);
  }
}
