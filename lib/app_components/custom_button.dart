import 'package:flutter/material.dart';

import '../configs/constants.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.text,
    this.isSelected = true,
    required this.onPressed,
    this.minButtonWidth = kButtonMinWidth,
    this.setToBackgroundColor = false,
    this.disable = false,
    this.fontSize = 15,
  });

  final String text;
  final bool isSelected;
  final VoidCallback? onPressed;
  final double minButtonWidth;
  final bool setToBackgroundColor;
  final bool disable;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    Color color = Theme.of(context).colorScheme.primary;
    if (setToBackgroundColor) {
      color = Theme.of(context).colorScheme.onBackground;
    }
    final widthPadding = size.width * 0.03;
    final heightPadding = size.height * 0.01;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.003),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadiusBig),
        child: Material(
          color: Theme.of(context)
              .colorScheme
              .shadow
              .withOpacity(kOpacityOnButton),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minWidth: size.width * minButtonWidth,
                minHeight: size.height * 0.05),
            child: InkWell(
              onTap: onPressed,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                    widthPadding, heightPadding, widthPadding, heightPadding),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Center(
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            fontSize: fontSize,
                            fontWeight: isSelected && !disable
                                ? FontWeight.bold
                                : FontWeight.w300,
                            color: isSelected && !disable
                                ? color
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
