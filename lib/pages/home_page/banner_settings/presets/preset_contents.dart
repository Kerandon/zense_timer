import 'package:zense_timer/configs/constants.dart';
import 'package:zense_timer/enums/bell.dart';
import 'package:zense_timer/enums/interval_bell_type.dart';
import 'package:zense_timer/utils/methods/date_time_methods.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../enums/ambience.dart';
import '../../../../models/prefs_model.dart';

class PresetContents extends StatelessWidget {
  const PresetContents({Key? key, required this.preset}) : super(key: key);

  final PrefsModel preset;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    String countdown = 'None';
    IconData countdownIcon = Icons.timer_outlined;
    if (preset.countdownTime > 0) {
      countdown = preset.countdownTime.formatFromMilliseconds();
    } else {
      countdownIcon = Icons.timer_off_outlined;
    }

    final bellVolume = (preset.bellVolume * 10).round().toString();
    bool bellIsOn = true;
    if (preset.bellOnStartSound.name == kNone &&
        preset.bellIntervalSound.name == kNone &&
        preset.bellOnEndSound.name == kNone) {
      bellIsOn = false;
    }

    String time = 'Open-ended session';
    IconData timeIcon = Icons.hourglass_bottom_outlined;
    if (preset.openSession) {
      timeIcon = FontAwesomeIcons.infinity;
    } else {
      time = preset.time.formatFromMilliseconds();
    }

    IconData startBellIcon = FontAwesomeIcons.bellSlash;
    String startBellValue = "None";

    if (preset.bellOnStartSound.name != kNone) {
      startBellIcon = FontAwesomeIcons.bell;
      startBellValue = preset.bellOnStartSound.toText();
    }

    IconData intervalBellIcon = FontAwesomeIcons.bellSlash;
    String intervalBellValue = "None";

    if (preset.bellIntervalSound.name != kNone) {
      if (preset.bellType == BellType.fixed) {
        intervalBellIcon = FontAwesomeIcons.bell;
        intervalBellValue =
            'Fixed ${preset.bellIntervalSound.toText()} every ${preset.bellFixedTime.formatFromMilliseconds()}';
      } else {
        intervalBellIcon = FontAwesomeIcons.bell;
        intervalBellValue =
            'Random ${preset.bellIntervalSound.toText()} every ${preset.bellRandom.min.formatFromMilliseconds()} - ${preset.bellRandom.max.formatFromMilliseconds()}';
      }
    }

    IconData endBellIcon = FontAwesomeIcons.bellSlash;
    String endBellValue = "None";

    if (preset.bellOnEndSound.name != kNone) {
      endBellIcon = FontAwesomeIcons.bell;
      endBellValue = preset.bellOnEndSound.toText();
    }

    String ambienceVolume = (preset.ambienceVolume * 10).round().toString();

    String ambience = 'None';
    IconData ambienceIcon = Icons.piano_off_outlined;
    if (preset.ambience.name != Ambience.none.name) {
      ambience = preset.ambience.toText().capitalize();
      ambienceIcon = preset.ambience.toIcon();
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: size.height * 0.03),
          child: Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(5),
              2: FlexColumnWidth(8)
            },
            children: [
              buildTableRow(
                context: context,
                icon: timeIcon,
                title: 'Time',
                text: time,
              ),
              buildTableRow(
                context: context,
                icon: countdownIcon,
                title: 'Countdown',
                text: countdown,
              ),
              if (bellIsOn) ...[
                buildTableRow(
                  context: context,
                  icon: intervalBellIcon,
                  title: 'Bell volume',
                  text: bellVolume,
                ),
              ],
              buildTableRow(
                context: context,
                icon: startBellIcon,
                title: 'Start bell',
                text: startBellValue,
              ),
              buildTableRow(
                  context: context,
                  icon: intervalBellIcon,
                  title: 'Interval bell',
                  text: intervalBellValue),
              buildTableRow(
                context: context,
                icon: endBellIcon,
                title: 'End bell',
                text: endBellValue,
              ),
              if (ambience != kNone.capitalize()) ...[
                buildTableRow(
                  context: context,
                  icon: ambienceIcon,
                  title: 'Ambience volume',
                  text: ambienceVolume,
                ),
              ],
              buildTableRow(
                context: context,
                icon: ambienceIcon,
                title: 'Ambience',
                text: ambience,
              ),
            ],
          ),
        ),
      ],
    );
  }

  TableRow buildTableRow(
      {required BuildContext context,
      required IconData icon,
      required String title,
      required String text}) {
    return TableRow(
      children: [
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            icon,
            size: 15,
            color: Theme.of(context).colorScheme.primary,
          ),
        )),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Text(
              text,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(),
            ),
          ),
        ),
      ],
    );
  }
}
