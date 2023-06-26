import 'package:equatable/equatable.dart';
import '../enums/time_period.dart';
import '../state/database_service.dart';

class StatsModel extends Equatable {
  final DateTime dateTime;
  final int totalMeditationTime;
  final TimePeriod? timePeriod;

  const StatsModel({
    required this.dateTime,
    required this.totalMeditationTime,
    this.timePeriod = TimePeriod.week,
  });

  factory StatsModel.fromMap(
      {required Map<String, dynamic> map,
      TimePeriod timePeriod = TimePeriod.allTime}) {
    String dateTime = map[DatabaseServiceAppData.statsDateTimeColumn];

    var statsModel = StatsModel(
      dateTime: DateTime.parse(dateTime),
      totalMeditationTime:
          map[DatabaseServiceAppData.statsTotalMeditationTimeColumn],
      timePeriod: timePeriod,
    );

    return statsModel;
  }

  @override
  List<Object?> get props {
    switch (timePeriod!) {
      case TimePeriod.week:
        return [dateTime.weekday];
      case TimePeriod.fortnight:
        return [dateTime.day];
      case TimePeriod.year:
        return [dateTime.month];
      case TimePeriod.allTime:
        return [dateTime.year];
    }
  }
}
