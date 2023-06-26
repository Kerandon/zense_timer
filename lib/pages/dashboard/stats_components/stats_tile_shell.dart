import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../configs/constants.dart';

class StatsTileShell extends StatefulWidget {
  const StatsTileShell(
      {Key? key, required this.closedContents, this.openContents})
      : super(key: key);

  final Widget closedContents;
  final Widget? openContents;

  @override
  State<StatsTileShell> createState() => _StatsTileShellState();
}

class _StatsTileShellState extends State<StatsTileShell> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * kStatsTilePadding),
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(kBorderRadiusBig)),
        child: OpenContainer(
            tappable: widget.openContents != null,
            closedColor: Theme.of(context).colorScheme.surface,
            openColor: Theme.of(context).colorScheme.surface,
            closedBuilder: (context, actions) => Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * kPageIndentation),
                // padding: const EdgeInsets.all(8.0),
                child: widget.closedContents),
            openBuilder: (context, actions) =>
                widget.openContents ?? const SizedBox.shrink()),
      )
          .animate()
          .scaleXY(begin: kScaleInBegin, duration: kFadeInTimeFast.milliseconds)
          .fadeIn(begin: 0),
    );
  }
}
