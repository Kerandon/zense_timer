import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class GuideTextBox extends StatelessWidget {
  const GuideTextBox({
    Key? key,
    required this.text,
    this.isHeading = false,
    required this.delayIndex,
  }) : super(key: key);

  final String text;
  final bool isHeading;
  final int delayIndex;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final animDuration = 1600.milliseconds;
    final delay = (delayIndex * 200).milliseconds;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.02),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: isHeading ? FontWeight.bold : FontWeight.normal,
              color: isHeading
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).textTheme.bodyLarge!.color,
            ),
      )
          .animate()
          .slideY(
            begin: -0.05,
            duration: animDuration,
            delay: delay,
          )
          .fadeIn(duration: animDuration, delay: delay),
    );
  }
}
