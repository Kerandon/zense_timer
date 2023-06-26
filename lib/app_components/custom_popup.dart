import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zense_timer/animation/fade_in_animation.dart';

import '../configs/constants.dart';

class CustomPopupBox extends StatelessWidget {
  const CustomPopupBox({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heightPadding = size.height * 0.03;
    final widthPadding = size.width * 0.15;
    return FadeInAnimation(
      child: Center(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(kBorderRadiusBig),
              boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor.withOpacity(0.30),
                    offset: const Offset(1, 1),
                    blurRadius: 5)
              ],
              color: Theme.of(context).colorScheme.background),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                widthPadding, heightPadding, widthPadding, heightPadding),
            child: Text(text),
          ),
        ),
      )
          .animate()
          .fadeIn(duration: 100.milliseconds, delay: 1.seconds)
          .fadeOut(duration: 100.milliseconds, delay: 10.seconds),
    );
  }
}
