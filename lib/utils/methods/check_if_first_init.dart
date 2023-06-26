import 'package:shared_preferences/shared_preferences.dart';

import '../../configs/constants.dart';

Future<bool> checkIfDNDShownOnInit() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(kDNDShownOnInit) ?? false;
}

Future<bool> setDNDPrefs() async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(kDNDShownOnInit, true);
}

Future<bool> checkIfPresetsOnFirstInitSaved() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(kPresetsOnInitPrefs) ?? false;
}

Future<bool> setPresetsOnFirstInit() async {
  final prefs = await SharedPreferences.getInstance();
  return await prefs.setBool(kPresetsOnInitPrefs, true);
}
