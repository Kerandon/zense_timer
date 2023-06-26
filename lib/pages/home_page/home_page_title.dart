import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../configs/constants.dart';
import '../../configs/themes/app_colors.dart';
import '../../enums/session_state.dart';
import '../../state/app_state.dart';

class HomePageTitle extends ConsumerStatefulWidget {
  const HomePageTitle({
    super.key,
  });

  @override
  ConsumerState<HomePageTitle> createState() => _HomePageTitleState();
}

class _HomePageTitleState extends ConsumerState<HomePageTitle> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final appState = ref.watch(appProvider);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: size.width * 0.06,
          height: size.width * 0.06,
          child: Padding(
              padding: EdgeInsets.only(right: size.width * 0.02),
              child: Image.asset('assets/images/icon/app_icon_black.png',
                  color: appState.colorTheme == AppColorTheme.simple
                      ? AppColors.defaultAppColor
                      : Theme.of(context).colorScheme.primary)),
        ),
        Text(
          kAppName,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (appState.sessionState == SessionState.notStarted) ...[
          const SizedBox(
            width: 56,
          ),
        ],
      ],
    );
  }
}
