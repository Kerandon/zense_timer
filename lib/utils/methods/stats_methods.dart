import 'package:zense_timer/utils/methods/date_time_methods.dart';

import '../../enums/time_period.dart';
import '../../models/stats_model.dart';
import '../../state/chart_state.dart';

int getCurrentStreak(List<StatsModel> stats) {
  int currentStreak = 0;

  DateTime now = DateTime.now();

  for (int i = 0; i < stats.length; i++) {
    final s = stats[i].dateTime;
    var t = DateTime(s.year, s.month, s.day);
    var d = DateTime(now.year, now.month, now.day - i);

    if (t.compareTo(d) == 0) {
      currentStreak++;
    } else {
      break;
    }
  }

  return currentStreak;
}

int getBestStreak(List<StatsModel> stats) {
  List<DateTime> dates = [];
  for (var s in stats) {
    dates.add(s.dateTime);
  }
  dates = dates.reversed.toList();

  int longestStreakLength = 0, currentStreakLength = 0;

  for (int i = 0; i < dates.length; i++) {
    if (i == 0 ||
        dates[i].compareTo(DateTime(
                dates[i].year, dates[i].month, dates[i - 1].day + 1)) ==
            0) {
      currentStreakLength++;
    } else {
      currentStreakLength = 1;
    }

    if (currentStreakLength > longestStreakLength) {
      longestStreakLength = currentStreakLength;
    }
  }

  return longestStreakLength;
}

String calculateTotalMeditationTime(List<StatsModel> data, ChartState state) {
  int totalTime = 0;

  for (var d in data) {
    totalTime += d.totalMeditationTime;
  }
  String totalTimeFormatted = totalTime.formatFromMilliseconds();
  String timeString;

  switch (state.barChartTimePeriod) {
    case TimePeriod.week:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.fortnight:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.year:
      timeString = totalTimeFormatted;
      break;
    case TimePeriod.allTime:
      timeString = totalTimeFormatted;
      break;
  }
  return timeString;
}
