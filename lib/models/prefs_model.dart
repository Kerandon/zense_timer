import 'dart:convert';
import 'package:zense_timer/models/bell_random.dart';
import 'package:equatable/equatable.dart';
import '../data/bell_times.dart';
import '../enums/ambience.dart';
import '../enums/bell.dart';
import '../enums/app_color_themes.dart';
import '../enums/clock_design.dart';
import '../enums/interval_bell_type.dart';
import '../enums/prefs.dart';

class PrefsModel extends Equatable {
  final String? name;
  final bool openSession;
  final int time;
  final int countdownTime;
  final double bellVolume;
  final Bell bellOnStartSound;
  final Bell bellIntervalSound;
  final BellType bellType;
  final int bellFixedTime;
  final BellRandom bellRandom;
  final Bell bellOnEndSound;
  final Ambience ambience;
  final double ambienceVolume;
  final AppColorTheme colorTheme;
  final bool followOSTheme;
  final bool darkTheme;
  final bool showTimer;
  final TimerDesign timerDesign;
  final bool reverseTimer;
  final bool vibrate;
  final bool muteDevice;
  final bool keepAwake;

  const PrefsModel({
    this.name,
    required this.openSession,
    required this.time,
    required this.countdownTime,
    required this.bellVolume,
    required this.bellOnStartSound,
    required this.bellIntervalSound,
    required this.bellType,
    required this.bellFixedTime,
    required this.bellRandom,
    required this.bellOnEndSound,
    required this.ambience,
    required this.ambienceVolume,
    required this.colorTheme,
    required this.followOSTheme,
    required this.darkTheme,
    required this.showTimer,
    required this.timerDesign,
    required this.reverseTimer,
    required this.vibrate,
    required this.muteDevice,
    required this.keepAwake,
  });

  /// Get last app settings when init. E.g. when the app loads it reverts to it's most recent state.
  /// Each entry is saved as a new row into SQLITE therefore using a 'for-loop' to iterate over
  /// the results

  factory PrefsModel.fromMapPrefs(List<Map<String, dynamic>> mapList) {
    bool openSession = false;
    int time = 600000;
    int countdownTime = 5000;
    double bellVolume = 0.50;
    Bell bellOnStartSound = Bell.bell;
    Bell bellIntervalSound = Bell.bell;
    BellType bellType = BellType.fixed;
    int bellFixedTime = 30000;
    BellRandom bellRandom = randomBells[1];
    Bell bellOnEndSound = Bell.chimesMultiple;
    Ambience ambience = Ambience.none;
    double ambienceVolume = 0.5;
    AppColorTheme colorTheme = AppColorTheme.simple;
    bool followOSTheme = false;
    bool darkTheme = true;
    bool showTimer = true;
    TimerDesign timerDesign = TimerDesign.circle;
    bool reverseTimer = true;
    bool vibrate = true;
    bool muteDevice = false;
    bool keepAwake = true;

    for (int i = 0; i < mapList.length; i++) {
      String prefKey = mapList[i].entries.elementAt(0).value;

      prefKey == Prefs.openSession.name
          ? openSession = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.time.name
          ? time = mapList[i].entries.elementAt(1).value
          : null;

      prefKey == Prefs.countdownTime.name
          ? countdownTime = mapList[i].entries.elementAt(1).value
          : null;

      prefKey == Prefs.bellVolume.name
          ? bellVolume = mapList[i].entries.elementAt(1).value
          : null;

      prefKey == Prefs.bellOnStartSound.name
          ? bellOnStartSound = Bell.values.firstWhere((element) {
              return element.name == mapList[i].entries.elementAt(1).value;
            }, orElse: () => Bell.bell)
          : null;

      prefKey == Prefs.bellIntervalSound.name
          ? bellIntervalSound = Bell.values.firstWhere((element) {
              return element.name == mapList[i].entries.elementAt(1).value;
            }, orElse: () => Bell.bell)
          : null;

      prefKey == Prefs.bellType.name
          ? bellType = BellType.values.firstWhere((element) {
              return element.name == mapList[i].entries.elementAt(1).value;
            }, orElse: () => BellType.fixed)
          : null;

      prefKey == Prefs.bellFixedTime.name
          ? bellFixedTime = mapList[i].entries.elementAt(1).value
          : null;

      prefKey == Prefs.bellRandom.name
          ? bellRandom = randomBells.firstWhere(
              (element) =>
                  element.index.toString() ==
                  mapList[i].entries.elementAt(1).value.toString(),
              orElse: () => randomBells[1])
          : null;

      prefKey == Prefs.bellOnEndSound.name
          ? bellOnEndSound = Bell.values.firstWhere((element) {
              return element.name == mapList[i].entries.elementAt(1).value;
            }, orElse: () => Bell.chimesMultiple)
          : null;

      prefKey == Prefs.ambience.name
          ? ambience = Ambience.values.firstWhere((element) {
              return element.name == mapList[i].entries.elementAt(1).value;
            }, orElse: () => Ambience.none)
          : null;

      prefKey == Prefs.ambienceVolume.name
          ? ambienceVolume = mapList[i].entries.elementAt(1).value
          : null;

      prefKey == Prefs.colorTheme.name
          ? colorTheme = AppColorTheme.values.firstWhere(
              (element) =>
                  element.name == mapList[i].entries.elementAt(1).value,
              orElse: () => AppColorTheme.sunrise)
          : null;

      prefKey == Prefs.followOSTheme.name
          ? followOSTheme = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.darkTheme.name
          ? darkTheme = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.showTimer.name
          ? showTimer = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.timerDesign.name
          ? timerDesign = TimerDesign.values.firstWhere(
              (element) =>
                  element.name == mapList[i].entries.elementAt(1).value,
              orElse: () => TimerDesign.dash)
          : null;

      prefKey == Prefs.reverseTimer.name
          ? reverseTimer = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.vibrate.name
          ? vibrate = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.muteDevice.name
          ? muteDevice = mapList[i].entries.elementAt(1).value == 1
          : null;

      prefKey == Prefs.keepAwake.name
          ? keepAwake = mapList[i].entries.elementAt(1).value == 1
          : null;
    }

    return PrefsModel(
      openSession: openSession,
      time: time,
      countdownTime: countdownTime,
      bellVolume: bellVolume,
      bellOnStartSound: bellOnStartSound,
      bellIntervalSound: bellIntervalSound,
      bellFixedTime: bellFixedTime,
      bellRandom: bellRandom,
      bellType: bellType,
      bellOnEndSound: bellOnEndSound,
      ambience: ambience,
      ambienceVolume: ambienceVolume,
      colorTheme: colorTheme,
      followOSTheme: followOSTheme,
      darkTheme: darkTheme,
      showTimer: showTimer,
      timerDesign: timerDesign,
      reverseTimer: reverseTimer,
      vibrate: vibrate,
      muteDevice: muteDevice,
      keepAwake: keepAwake,
    );
  }

  /// Used to save to, and get from SQLite, a single [PrefsModel] object saved as a [BLOB] to
  /// represent a CUSTOM PRESET.

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      Prefs.openSession.name: openSession,
      Prefs.time.name: time,
      Prefs.countdownTime.name: countdownTime,
      Prefs.bellVolume.name: bellVolume,
      Prefs.bellOnStartSound.name: bellOnStartSound.name,
      Prefs.bellIntervalSound.name: bellIntervalSound.name,
      Prefs.bellType.name: bellType.name,
      Prefs.bellFixedTime.name: bellFixedTime,
      Prefs.bellRandom.name: bellRandom.index,
      Prefs.bellOnEndSound.name: bellOnEndSound.name,
      Prefs.ambience.name: ambience.name,
      Prefs.ambienceVolume.name: ambienceVolume,
      Prefs.colorTheme.name: colorTheme.name,
      Prefs.followOSTheme.name: followOSTheme,
      Prefs.darkTheme.name: darkTheme,
      Prefs.showTimer.name: showTimer,
      Prefs.timerDesign.name: timerDesign.name,
      Prefs.reverseTimer.name: reverseTimer,
      Prefs.vibrate.name: vibrate,
    };
  }

  factory PrefsModel.fromMapPresets({required Map<String, dynamic> map}) {
    var name = map.entries.elementAt(0).value;

    final data =
        jsonDecode(map.entries.elementAt(1).value) as Map<String, dynamic>;

    final bellOnStartSound = Bell.values.firstWhere(
      (element) => element.name == data[Prefs.bellOnStartSound.name],
      orElse: () => Bell.bell,
    );

    final bellIntervalSound = Bell.values.firstWhere(
      (element) => element.name == data[Prefs.bellIntervalSound.name],
      orElse: () => Bell.bell,
    );

    final bellOnEndSound = Bell.values.firstWhere(
      (element) => element.name == data[Prefs.bellOnEndSound.name],
      orElse: () => Bell.chimesMultiple,
    );

    final bellType = BellType.values.firstWhere(
      (element) => element.name == data[Prefs.bellType.name],
      orElse: () => BellType.fixed,
    );

    /// Match the random bell by the [index] property in the [BellRandom] class
    final bellRandom = randomBells.firstWhere(
        (element) => element.index == data[Prefs.bellRandom.name],
        orElse: () => randomBells[1]);

    final ambience = Ambience.values.firstWhere(
      (element) => element.name == data[Prefs.ambience.name],
      orElse: () => Ambience.none,
    );

    final colorTheme = AppColorTheme.values.firstWhere(
      (element) => element.name == data[Prefs.colorTheme.name],
      orElse: () => AppColorTheme.simple,
    );

    final timerDesign = TimerDesign.values.firstWhere(
        (element) => element.name == data[Prefs.timerDesign.name],
        orElse: () => TimerDesign.circle);
    return PrefsModel(
      name: name.toString(),
      openSession: data[Prefs.openSession.name],
      time: data[Prefs.time.name] ?? 600000,
      countdownTime: data[Prefs.countdownTime.name] ?? 5000,
      bellVolume: data[Prefs.bellVolume.name] ?? 1.0,
      bellOnStartSound: bellOnStartSound,
      bellIntervalSound: bellIntervalSound,
      bellType: bellType,
      bellFixedTime: data[Prefs.bellFixedTime.name] ?? 30000,
      bellRandom: bellRandom,
      bellOnEndSound: bellOnEndSound,
      ambience: ambience,
      ambienceVolume: data[Prefs.ambienceVolume.name] ?? false,
      colorTheme: colorTheme,
      followOSTheme: data[Prefs.followOSTheme.name] ?? false,
      darkTheme: data[Prefs.darkTheme.name] ?? true,
      showTimer: data[Prefs.showTimer.name] ?? true,
      timerDesign: timerDesign,
      reverseTimer: data[Prefs.reverseTimer.name] ?? true,
      vibrate: data[Prefs.vibrate.name] ?? true,
      muteDevice: data[Prefs.muteDevice.name] ?? false,
      keepAwake: data[Prefs.keepAwake.name] ?? true,
    );
  }

  /// Ensure each [PrefsModel] by name, is unique, so there will not be duplicate CUSTOM PRESETS.
  @override
  List<Object?> get props => [name];
}
