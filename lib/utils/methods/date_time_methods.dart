extension DurationFormatter on int {
  String formatFromMilliseconds() {
    if (this == 0) {
      return '0';
    }
    // Convert the input from milliseconds to seconds
    int seconds = this ~/ 1000;

    // Calculate the number of days, hours, minutes and seconds from the input
    int days = seconds ~/ (24 * 60 * 60);
    int hours = (seconds % (24 * 60 * 60)) ~/ (60 * 60);
    int minutes = (seconds % (60 * 60)) ~/ 60;
    seconds = seconds % 60;

    // Use a string buffer to build the output
    StringBuffer buffer = StringBuffer();

    // Add the days part if it is not zero
    if (days > 0) {
      buffer.write('${days}d ');
    }

    // Add the hours part if it is not zero
    if (hours > 0) {
      buffer.write('${hours}h ');
    }

    // Add the minutes part if it is not zero
    if (minutes > 0) {
      buffer.write('${minutes}m ');
    }

    // Add the seconds part if it is not zero
    if (seconds > 0) {
      buffer.write('${seconds}s');
    }

    // Trim any trailing spaces and return the result
    return buffer.toString().trim();
  }
}

extension DateSuffix on int {
  String addDateSuffix() {
    if (this >= 11 && this <= 13) {
      return 'th';
    }

    switch (this % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
