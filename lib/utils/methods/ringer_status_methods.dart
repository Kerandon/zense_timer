import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';

import '../../state/app_state.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;

Future<RingerModeStatus> getRingerModeStatus() async {
  return await SoundMode.ringerModeStatus;
}

Future<RingerModeStatus> setDND(
    {required bool on, required AppState state}) async {
  final status =
      await permissions.Permission.accessNotificationPolicy.request();
  final ringerStatus = await SoundMode.ringerModeStatus;
  if (on && status.isGranted) {
    if (ringerStatus == RingerModeStatus.silent) {
      return RingerModeStatus.silent;
    } else {
      return await SoundMode.setSoundMode(RingerModeStatus.silent);
    }
  } else {
    if (ringerStatus == RingerModeStatus.silent) {
      return RingerModeStatus.normal;
    } else {
      return await SoundMode.setSoundMode(state.originalRingerModeStatus);
    }
  }
}
