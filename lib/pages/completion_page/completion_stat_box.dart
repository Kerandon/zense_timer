import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import '../../configs/constants.dart';

class CompletionStatBox extends StatelessWidget {
  const CompletionStatBox({
    super.key,
    required this.text,
    required this.onTap,
    this.value,
    this.icon,
  });

  final String text;
  final VoidCallback onTap;
  final String? value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(size.width * 0.01),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(kBorderRadiusBig),
        child: Material(
          color: Theme.of(context)
              .colorScheme
              .shadow
              .withOpacity(kOpacityOnButton),
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: EdgeInsets.all(size.width * 0.02),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (icon != null) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: Icon(
                          icon,
                          color: Theme.of(context).colorScheme.primary,
                          size: 40,
                        ),
                      ),
                    )
                  ],
                  if (value != null) ...[
                    Expanded(
                      child: Align(
                        alignment: Alignment.center,
                        child: AutoSizeText(
                          value!,
                          textAlign: TextAlign.center,
                          minFontSize: 8,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                              ),
                        ),
                      ),
                    ),
                  ],
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        text,
                        style: Theme.of(context).textTheme.labelSmall,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
