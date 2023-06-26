import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ControlButton extends ConsumerWidget {
  const ControlButton({
    required this.onPressed,
    required this.icon,
    this.disable = false,
    this.color,
    super.key,
  });

  final VoidCallback onPressed;
  final IconData icon;
  final bool disable;
  final Color? color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    return SizedBox(
      width: size.width * 0.12,
      height: size.width * 0.12,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: appState.colorTheme == AppColorTheme.simple
                  ? Theme.of(context).colorScheme.surface
                  : Theme.of(context)
                      .colorScheme
                      .tertiary
                      .withOpacity(kHomeScreenBackdropOpacity),
              borderRadius: BorderRadius.circular(500),
            ),
            child: IconButton(
              icon: Icon(
                icon,
                color: color,
              ),
              onPressed: disable ? null : onPressed,
            ),
          ),
        ],
      ),
    );
  }
}
