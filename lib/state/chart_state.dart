import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../enums/time_period.dart';

class ChartState {
  final bool toggleBarChart;
  final bool haveData;
  final TimePeriod barChartTimePeriod;
  final Map<int, DateTime> selectedMeditationEvents;

  ChartState({
    required this.toggleBarChart,
    required this.haveData,
    required this.barChartTimePeriod,
    required this.selectedMeditationEvents,
  });

  ChartState copyWith({
    bool? toggleBarChart,
    bool? haveData,
    TimePeriod? barChartTimePeriod,
    Map<int, DateTime>? selectedMeditationEvents,
  }) {
    return ChartState(
      toggleBarChart: toggleBarChart ?? this.toggleBarChart,
      haveData: haveData ?? this.haveData,
      barChartTimePeriod: barChartTimePeriod ?? this.barChartTimePeriod,
      selectedMeditationEvents:
          selectedMeditationEvents ?? this.selectedMeditationEvents,
    );
  }
}

class ChartNotifier extends StateNotifier<ChartState> {
  ChartNotifier(state) : super(state);

  void setBarChartToggle(bool toggle) {
    state = state.copyWith(toggleBarChart: toggle);
  }

  void setHaveData(bool haveData) {
    state = state.copyWith(haveData: haveData);
  }

  void setBarChartTimePeriod(TimePeriod time) {
    state = state.copyWith(barChartTimePeriod: time);
  }

  void selectMeditationEvents({
    required Map<int, DateTime> items,
    bool unselect = false,
  }) {
    Map<int, DateTime> events = state.selectedMeditationEvents;

    for (int i = 0; i < items.length; i++) {
      final item = items.entries.elementAt(i);
      if (unselect == false) {
        events.addAll({item.key: item.value});
      } else {
        events.remove(item.key);
      }
    }

    state = state.copyWith(selectedMeditationEvents: events);
  }

  void clearAllMeditationEvents() {
    state = state.copyWith(selectedMeditationEvents: {});
  }
}

final chartStateProvider =
    StateNotifierProvider<ChartNotifier, ChartState>((ref) {
  return ChartNotifier(ChartState(
    toggleBarChart: false,
    haveData: true,
    barChartTimePeriod: TimePeriod.week,
    selectedMeditationEvents: {},
  ));
});
