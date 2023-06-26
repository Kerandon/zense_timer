import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../../enums/app_color_themes.dart';
import '../../../../../state/app_state.dart';

class NumberBox extends ConsumerWidget {
  const NumberBox(
    this.number, {
    super.key,
  });

  final String number;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appState = ref.watch(appProvider);
    return SizedBox(
      width: 26,
      height: 60,
      child: Center(
        child: Text(
          number,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: !appState.darkTheme &&
                        appState.colorTheme == AppColorTheme.simple
                    ? Colors.black
                    : Colors.white,
              ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
