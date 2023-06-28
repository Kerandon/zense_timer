import 'package:zense_timer/animation/fade_in_animation.dart';
import 'package:flutter/material.dart';
import '../../../configs/constants.dart';

class HeadlineTile extends StatelessWidget {
  const HeadlineTile({
    super.key,
    required this.content,
    this.removeBackgroundColor = false,
  });

  final Widget content;
  final bool removeBackgroundColor;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final widthPadding = size.width * kPageIndentation;
    final heightPadding = size.height * 0.03;
    return FadeInAnimation(
      child: Padding(
        padding: EdgeInsets.all(size.width * kStatsTilePadding),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kBorderRadiusBig),
            color: removeBackgroundColor
                ? Colors.transparent
                : Theme.of(context).colorScheme.surface,
          ),
          width: size.width,
          child: Center(
              child: Padding(
            padding: EdgeInsets.fromLTRB(
              widthPadding,
              heightPadding,
              widthPadding,
              heightPadding,
            ),
            child: content,
          )),
        ),
      ),
    );
  }
}
