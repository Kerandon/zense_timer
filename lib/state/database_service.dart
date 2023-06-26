import 'dart:convert';
import 'package:zense_timer/enums/time_period.dart';
import 'package:zense_timer/models/prefs_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../enums/prefs.dart';
import '../models/stats_model.dart';

class DatabaseServiceAppData {
  DatabaseServiceAppData._internal();

  static final _instance = DatabaseServiceAppData._internal();

  factory DatabaseServiceAppData() => _instance;

  Database? _database;

  static const String _databaseName = 'app_data5',
      _prefsTable = 'prefs_table',
      prefsKeyColumn = 'k',
      prefsValueColumn = 'v',
      _statsTable = 'stats_table',
      statsDateTimeColumn = 'date_time',
      statsTotalMeditationTimeColumn = 'meditation_time',
      _presetsTable = 'presets_table',
      _presetsNameColumn = 'presets_name',
      _presetsDataColumn = 'presets_data';

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(path, onCreate: (db, version) async {
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $_prefsTable($prefsKeyColumn TEXT PRIMARY KEY, $prefsValueColumn BLOB NOT NULL)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $_statsTable($statsDateTimeColumn TEXT PRIMARY KEY, $statsTotalMeditationTimeColumn INT NOT NULL)');
      await db.execute(
          'CREATE TABLE IF NOT EXISTS $_presetsTable($_presetsNameColumn TEXT PRIMARY KEY, $_presetsDataColumn BLOB NOT NULL)');
    }, version: 1);
  }

  /// PREFERENCES

  Future<int> insertIntoPrefs({required String k, required dynamic v}) async {
    _database = await _initDatabase();
    return await _database!.rawInsert(
        'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
        [k, v]);
  }

  Future<dynamic> insertAllIntoPrefs({required PrefsModel prefs}) async {
    _database = await _initDatabase();
    return await _database!.transaction((txn) async {
      final batch = txn.batch();
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.time.name, prefs.time]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.openSession.name, prefs.openSession]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.countdownTime.name, prefs.countdownTime]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellVolume.name, prefs.bellVolume]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellOnStartSound.name, prefs.bellOnStartSound.name]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellIntervalSound.name, prefs.bellIntervalSound.name]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellType.name, prefs.bellType.name]);

      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellFixedTime.name, prefs.bellFixedTime]);

      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellRandom.name, prefs.bellRandom.index]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.bellOnEndSound.name, prefs.bellOnEndSound.name]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.ambience.name, prefs.ambience.name]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.ambienceVolume.name, prefs.ambienceVolume]);
      batch.rawInsert(
          'INSERT OR REPLACE INTO $_prefsTable($prefsKeyColumn, $prefsValueColumn) VALUES(?, ?)',
          [Prefs.vibrate.name, prefs.vibrate]);

      return await batch.commit();
    });
  }

  Future<PrefsModel> getPrefs() async {
    _database = await _initDatabase();
    final mapsList = await _database!.rawQuery('SELECT * FROM $_prefsTable');
    return PrefsModel.fromMapPrefs(mapsList);
  }

  /// STATS

  Future<int> insertIntoStats(
      {required DateTime dateTime, required int milliseconds}) async {
    _database = await _initDatabase();
    return await _database!.rawInsert(
        'INSERT OR REPLACE INTO $_statsTable($statsDateTimeColumn, $statsTotalMeditationTimeColumn) VALUES (?,?)',
        [dateTime.toString(), milliseconds]);
  }

  Future<List<StatsModel>> getStatsByTimePeriod(
      {TimePeriod? period,
      bool? allTimeGroupedByDay,
      bool? allTimeUngrouped}) async {
    final db = await _initDatabase();

    List<Map<String, dynamic>> data = [];

    if (allTimeUngrouped == true) {
      data = await db.rawQuery(
          'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable ORDER BY date($statsDateTimeColumn) DESC');
    } else if (allTimeGroupedByDay == true) {
      data = await db.rawQuery(
          'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn) ORDER BY date($statsDateTimeColumn) DESC');
    } else {
      if (period == TimePeriod.week) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-7 day\')) GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.fortnight) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-14 day\')) GROUP BY strftime("%d-%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.year) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable WHERE $statsDateTimeColumn > (SELECT DATETIME(\'now\', \'-1 year\')) GROUP BY strftime("%m-%Y", $statsDateTimeColumn)');
      } else if (period == TimePeriod.allTime) {
        data = await db.rawQuery(
            'SELECT SUM($statsTotalMeditationTimeColumn) as $statsTotalMeditationTimeColumn,  strftime("%Y-%m-%d", $statsDateTimeColumn) as \'$statsDateTimeColumn\' from $_statsTable GROUP BY strftime("%Y", $statsDateTimeColumn)');
      }
    }

    return List.generate(
      data.length,
      (index) => StatsModel.fromMap(
        map: data.elementAt(index),
        timePeriod: period!,
      ),
    ).toList();
  }

  Future<StatsModel> getLastEntry() async {
    _database = await _initDatabase();
    final map = await _database!.rawQuery(
        'SELECT * FROM $_statsTable ORDER BY $statsDateTimeColumn DESC LIMIT 1');
    return StatsModel.fromMap(map: map.first, timePeriod: TimePeriod.allTime);
  }

  Future<List<StatsModel>> getAllStats() async {
    _database = await _initDatabase();

    final maps = await _database!.rawQuery('SELECT * FROM $_statsTable');

    return List.generate(
        maps.length, (index) => StatsModel.fromMap(map: maps[index]));
  }

  Future<bool> removeStats(List<DateTime> dateTimes) async {
    _database = await _initDatabase();
    for (var d in dateTimes) {
      _database!.rawQuery(
          'DELETE FROM $_statsTable WHERE $statsDateTimeColumn = ?',
          [d.toString()]);
    }
    return true;
  }

  /// PRESETS

  Future<int> insertIntoPresets({required PrefsModel presetModel}) async {
    _database = await _initDatabase();
    return await _database!.rawInsert(
        'INSERT OR REPLACE INTO $_presetsTable($_presetsNameColumn, $_presetsDataColumn) VALUES(?,?)',
        [presetModel.name, jsonEncode(presetModel.toMap())]);
  }

  Future<List<PrefsModel>> getPresets() async {
    _database = await _initDatabase();
    final maps = await _database!.rawQuery('SELECT * FROM $_presetsTable');

    return List.generate(maps.length,
        (index) => PrefsModel.fromMapPresets(map: maps.elementAt(index)));
  }

  Future<int> deletePreset({required PrefsModel preset}) async {
    _database = await _initDatabase();
    return await _database!.rawDelete(
        'DELETE FROM $_presetsTable WHERE $_presetsNameColumn = ?',
        [preset.name.toString()]);
  }

  /// DELETE ALL

  Future<int> deleteAll() async {
    await databaseFactory
        .deleteDatabase(join(await getDatabasesPath(), _databaseName));
    return 1;
  }
}
