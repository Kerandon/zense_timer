import 'package:zense_timer/enums/ambience.dart';
import 'package:zense_timer/enums/interval_bell_type.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/bell_times.dart';
import '../enums/bell.dart';
import '../models/bell_random.dart';
import '../enums/prefs.dart';
import '../models/prefs_model.dart';
import 'database_service.dart';

class AudioState {
  final bool bellSoundPageIsOpen;
  final bool showBells;
  final double bellVolume;
  final Bell bellOnStartSound;
  final Bell bellIntervalSound;

  final BellType bellType;
  final int bellFixedTime;

  final BellRandom bellRandom;
  final Bell bellOnEndSound;

  final bool showAmbience;
  final Ambience ambience;
  final double ambienceVolume;
  final int ambiencePosition;

  AudioState({
    required this.bellSoundPageIsOpen,
    required this.showBells,
    required this.bellVolume,
    required this.bellOnStartSound,
    required this.bellIntervalSound,
    required this.bellType,
    required this.bellFixedTime,
    required this.bellRandom,
    required this.bellOnEndSound,
    required this.showAmbience,
    required this.ambience,
    required this.ambienceVolume,
    required this.ambiencePosition,
  });

  AudioState copyWith({
    bool? bellSoundPageIsOpen,
    bool? showBells,
    double? bellVolume,
    Bell? bellOnStartSound,
    Bell? bellIntervalSound,
    BellType? bellType,
    int? bellFixedTime,
    BellRandom? bellRandom,
    Bell? bellOnEndSound,
    bool? showAmbience,
    Ambience? ambience,
    double? ambienceVolume,
    int? ambiencePosition,
  }) {
    return AudioState(
      bellSoundPageIsOpen: bellSoundPageIsOpen ?? this.bellSoundPageIsOpen,
      showBells: showBells ?? this.showBells,
      bellVolume: bellVolume ?? this.bellVolume,
      bellOnStartSound: bellOnStartSound ?? this.bellOnStartSound,
      bellIntervalSound: bellIntervalSound ?? this.bellIntervalSound,
      bellOnEndSound: bellOnEndSound ?? this.bellOnEndSound,
      bellType: bellType ?? this.bellType,
      bellFixedTime: bellFixedTime ?? this.bellFixedTime,
      bellRandom: bellRandom ?? this.bellRandom,
      showAmbience: showAmbience ?? this.showAmbience,
      ambience: ambience ?? this.ambience,
      ambienceVolume: ambienceVolume ?? this.ambienceVolume,
      ambiencePosition: ambiencePosition ?? this.ambiencePosition,
    );
  }
}

class AudioNotifier extends StateNotifier<AudioState> {
  AudioNotifier(AudioState state) : super(state);

  /// BELLS

  void setBellSoundPageIsOpen(bool open) {
    state = state.copyWith(bellSoundPageIsOpen: open);
  }

  void showBells(bool show) {
    state = state.copyWith(showBells: show);
  }

  void setBellVolume(double volume, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellVolume: volume);
    await DatabaseServiceAppData()
        .insertIntoPrefs(k: Prefs.bellVolume.name, v: volume);
  }

  void setBellOnStartSound(Bell bell, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellOnStartSound: bell);
    await DatabaseServiceAppData()
        .insertIntoPrefs(k: Prefs.bellOnStartSound.name, v: bell.name);
  }

  void setIntervalBellSound(Bell bell, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellIntervalSound: bell);
    await DatabaseServiceAppData()
        .insertIntoPrefs(k: Prefs.bellIntervalSound.name, v: bell.name);
  }

  void setIntervalBellType(BellType bell,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(bellType: bell);
    await DatabaseServiceAppData()
        .insertIntoPrefs(k: Prefs.bellType.name, v: bell.name);
  }

  void setBellFixed(int interval, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellFixedTime: interval);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.bellFixedTime.name, v: interval);
    }
  }

  void setRandomRange(BellRandom bellRandom,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(bellRandom: bellRandom);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.bellRandom.name, v: bellRandom.index);
    }
  }

  void setBellOnEndSound(Bell bell, {bool insertInDatabase = true}) async {
    state = state.copyWith(bellOnEndSound: bell);
    await DatabaseServiceAppData()
        .insertIntoPrefs(k: Prefs.bellOnEndSound.name, v: bell.name);
  }

  /// AMBIENCE

  void setShowAmbience(bool show) {
    state = state.copyWith(showAmbience: show);
  }

  void setAmbience(Ambience ambience, {bool insertInDatabase = true}) async {
    state = state.copyWith(ambience: ambience);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.ambience.name, v: ambience.name);
    }
  }

  void setAmbienceVolume(double volume, {bool insertInDatabase = true}) async {
    state = state.copyWith(ambienceVolume: volume);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.ambienceVolume.name, v: volume);
    }
  }

  void setAmbiencePosition(int position) {
    state = state.copyWith(ambiencePosition: position);
  }

  /// SET ALL

  void setAllPrefs(PrefsModel p) {
    state = state.copyWith(
      bellVolume: p.bellVolume,
      bellOnStartSound: p.bellOnStartSound,
      bellIntervalSound: p.bellIntervalSound,
      bellType: p.bellType,
      bellFixedTime: p.bellFixedTime,
      bellRandom: p.bellRandom,
      bellOnEndSound: p.bellOnEndSound,
      ambience: p.ambience,
      ambienceVolume: p.ambienceVolume,
    );
  }
}

final audioProvider = StateNotifierProvider<AudioNotifier, AudioState>((ref) {
  return AudioNotifier(AudioState(
    bellSoundPageIsOpen: false,
    showBells: false,
    bellVolume: 1.0,
    bellOnStartSound: Bell.bell,
    bellIntervalSound: Bell.bell,
    bellType: BellType.fixed,
    bellFixedTime: 30000,
    bellRandom: randomBells[1],
    bellOnEndSound: Bell.chimesMultiple,
    showAmbience: false,
    ambience: Ambience.none,
    ambienceVolume: 0.50,
    ambiencePosition: 0,
  ));
});
