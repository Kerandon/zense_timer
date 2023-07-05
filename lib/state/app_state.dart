import 'package:zense_timer/enums/app_color_themes.dart';
import 'package:zense_timer/enums/session_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../configs/constants.dart';
import '../enums/clock_design.dart';
import '../enums/prefs.dart';
import '../models/prefs_model.dart';
import 'database_service.dart';

class AppState {
  ///APP STATE
  final SessionState sessionState;
  final bool appWasStopped;

  ///TIME
  final int time;
  final int elapsedTime;
  final int countdownTime;
  final bool openSession;

  ///PRESETS
  final bool showPresets;
  final String selectedPreset;

  ///THEME
  final AppColorTheme colorTheme;
  final bool followOSTheme;
  final bool darkTheme;
  final bool showTimer;
  final TimerDesign timerDesign;
  final bool reverseTimer;
  final bool showClock;

  ///VIBRATE
  final bool vibrate;

  AppState({
    required this.sessionState,
    required this.appWasStopped,
    required this.time,
    required this.elapsedTime,
    required this.countdownTime,
    required this.openSession,
    required this.showPresets,
    required this.selectedPreset,
    required this.colorTheme,
    required this.followOSTheme,
    required this.darkTheme,
    required this.showTimer,
    required this.showClock,
    required this.timerDesign,
    required this.reverseTimer,
    required this.vibrate,
  });

  AppState copyWith({
    SessionState? sessionState,
    int? time,
    bool? appWasStopped,
    int? elapsedTime,
    int? countdownTime,
    bool? openSession,
    bool? showPresets,
    String? selectedPreset,
    AppColorTheme? colorTheme,
    bool? followOSTheme,
    bool? darkTheme,
    bool? showTimer,
    bool? showClock,
    TimerDesign? timerDesign,
    bool? reverseTimer,
    bool? vibrate,
  }) {
    return AppState(
      time: time ?? this.time,
      sessionState: sessionState ?? this.sessionState,
      appWasStopped: appWasStopped ?? this.appWasStopped,
      elapsedTime: elapsedTime ?? this.elapsedTime,
      countdownTime: countdownTime ?? this.countdownTime,
      openSession: openSession ?? this.openSession,
      showPresets: showPresets ?? this.showPresets,
      selectedPreset: selectedPreset ?? this.selectedPreset,
      colorTheme: colorTheme ?? this.colorTheme,
      followOSTheme: followOSTheme ?? this.followOSTheme,
      darkTheme: darkTheme ?? this.darkTheme,
      showTimer: showTimer ?? this.showTimer,
      showClock: showClock ?? this.showClock,
      timerDesign: timerDesign ?? this.timerDesign,
      reverseTimer: reverseTimer ?? this.reverseTimer,
      vibrate: vibrate ?? this.vibrate,
    );
  }
}

class AppNotifier extends StateNotifier<AppState> {
  AppNotifier(state) : super(state);

  void setTime(
      {required int minutes,
      required int hours,
      bool insertInDatabase = true}) async {
    int updatedTotalTime =
        ((minutes + (hours * 60)) * 60000) % (24 * 60 * 60000);

    /// Prevent time being set to zero
    if (updatedTotalTime == 0) {
      updatedTotalTime = 60000;
    }

    state = state.copyWith(time: updatedTotalTime);

    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.time.name, v: updatedTotalTime);
    }
  }

  void setTotalTimeAfterRestart(int total) {
    state = state.copyWith(time: total);
  }

  void setSessionState(SessionState sessionState) {
    state = state.copyWith(sessionState: sessionState);
  }

  void resetSession() {
    state = state.copyWith(
      elapsedTime: 0,
    );
  }

  void setElapsedTime(int time) {
    state = state.copyWith(elapsedTime: time);
  }

  void setCountdownTime(int time, {bool insertInDatabase = true}) async {
    state = state.copyWith(countdownTime: time);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.countdownTime.name, v: time);
    }
  }

  void setOpenSession(bool open, {bool insertInDatabase = true}) async {
    state = state.copyWith(openSession: open);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.openSession.name, v: open);
    }
  }

  void setAppWasStopped(bool stopped) {
    state = state.copyWith(appWasStopped: stopped);
  }

  ///PRESETS

  void setShowPresets(bool show) {
    state = state.copyWith(showPresets: show);
  }

  void setSelectedPreset(String preset) {
    state = state.copyWith(selectedPreset: preset);
  }

  void setColorTheme(AppColorTheme colorTheme,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(colorTheme: colorTheme);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.colorTheme.name, v: colorTheme.name);
    }
  }

  void setFollowOSTheme(bool follow, {bool insertInDatabase = true}) async {
    state = state.copyWith(followOSTheme: follow);

    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.followOSTheme.name, v: follow);
    }
  }

  void setDarkTheme(bool isDark, {bool insertInDatabase = true}) async {
    state = state.copyWith(darkTheme: isDark);

    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.darkTheme.name, v: isDark);
    }
  }

  void showTimerDesign(bool show, {bool insertInDatabase = true}) async {
    state = state.copyWith(showTimer: show);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.showTimer.name, v: show);
    }
  }

  void setTimerDesign(TimerDesign design,
      {bool insertInDatabase = true}) async {
    state = state.copyWith(timerDesign: design);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.timerDesign.name, v: design.name);
    }
  }

  void setReverseTimer(bool reverse, {bool insertInDatabase = true}) async {
    state = state.copyWith(reverseTimer: reverse);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.reverseTimer.name, v: reverse);
    }
  }

  void setShowClock(bool show, {bool insertInDatabase = true}) async {
    state = state.copyWith(showClock: show);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.showClock.name, v: show);
    }
  }

  void setVibrate(bool vibrate, {bool insertInDatabase = true}) async {
    state = state.copyWith(vibrate: vibrate);
    if (insertInDatabase) {
      await DatabaseServiceAppData()
          .insertIntoPrefs(k: Prefs.vibrate.name, v: vibrate);
    }
  }

  void setAllPrefs(
      {required PrefsModel prefsModel, bool mainOnly = false}) async {
    /// These settings only need to be loaded once on first init
    state = state.copyWith(
      time: prefsModel.time,
      countdownTime: prefsModel.countdownTime,
      openSession: prefsModel.openSession,
    );

    /// These settings should be saved everytime they change
    if (!mainOnly) {
      state = state.copyWith(
        colorTheme: prefsModel.colorTheme,
        followOSTheme: prefsModel.followOSTheme,
        darkTheme: prefsModel.darkTheme,
        showTimer: prefsModel.showTimer,
        timerDesign: prefsModel.timerDesign,
        reverseTimer: prefsModel.reverseTimer,
        showClock: prefsModel.showClock,
        vibrate: prefsModel.vibrate,
      );
    }
  }
}

final appProvider = StateNotifierProvider<AppNotifier, AppState>((ref) {
  return AppNotifier(AppState(
    sessionState: SessionState.notStarted,
    colorTheme: AppColorTheme.simple,
    time: 600000,
    elapsedTime: 0,
    countdownTime: 5000,
    openSession: false,
    appWasStopped: false,
    showPresets: false,
    selectedPreset: kPresets,
    followOSTheme: false,
    darkTheme: true,
    showTimer: true,
    showClock: true,
    timerDesign: TimerDesign.circle,
    reverseTimer: true,
    vibrate: true,
  ));
});
