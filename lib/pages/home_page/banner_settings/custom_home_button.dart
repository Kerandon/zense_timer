import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:zense_timer/configs/constants.dart';

class CustomHomeButton extends StatelessWidget {
  const CustomHomeButton({
    super.key,
    required this.iconData,
    required this.onPressed,
    this.title,
  });

  final String? title;
  final IconData iconData;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          width: size.width / 4,
          height: size.height * 0.9,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: size.height * 0.003),
                child: Center(
                    child: Icon(
                  iconData,
                  size: 40,
                  color: Theme.of(context).colorScheme.primary,
                )),
              ),
              SizedBox(
                width: size.width / 4,
                height: size.height * 0.018,
                child: title != null
                    ? Text(
                        title!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall!.copyWith(
                              color: Theme.of(context).colorScheme.onBackground,
                              fontSize: 9,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
              ),
            ],
          ),
        ).animate().fadeIn(duration: kFadeInTimeFast.milliseconds),
      ),
    );
  }
}
