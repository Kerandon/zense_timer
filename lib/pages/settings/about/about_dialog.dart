import 'package:zense_timer/configs/constants.dart';
import 'package:flutter/material.dart';

import '../../../app_components/app_icon.dart';

class CustomAboutDialog extends StatelessWidget {
  const CustomAboutDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const AboutDialog(
      applicationName: kAppName,
      applicationVersion: '1.0.3',
      applicationIcon: AppIcon(),
      children: [
        Text(
          '$kAppName is produced by Zenbition Ltd.\n\n© 2023 All Rights Reserved.',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
