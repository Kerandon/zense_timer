enum DayTime { morning, afternoon, evening, lateNight }

extension TextExtension on DayTime {
  String toText() {
    switch (this) {
      case DayTime.morning:
        return 'Morning';
      case DayTime.afternoon:
        return 'Afternoon';
      case DayTime.evening:
        return 'Evening';
      case DayTime.lateNight:
        return 'Late Night';
    }
  }
}
