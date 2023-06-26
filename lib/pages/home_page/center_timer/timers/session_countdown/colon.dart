import 'package:zense_timer/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../enums/app_color_themes.dart';

class Colon extends ConsumerWidget {
  const Colon({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    return SizedBox(
        width: 16,
        height: 60,
        child: Center(
          child: Text(
            ':',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: !appState.darkTheme &&
                          appState.colorTheme == AppColorTheme.simple
                      ? Colors.black
                      : Colors.white,
                ),
            //Theme.of(context).colorScheme.onBackground)),
          ),
        ));
  }
}
