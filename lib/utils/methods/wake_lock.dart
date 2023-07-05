import 'package:wakelock/wakelock.dart';

Future<void> setWakeLock() async {
  await Wakelock.enable();
}
