import 'dart:math';

import '../../enums/ambience.dart';
import '../../enums/bell.dart';

List<String> getAllBellsToList() {
  List<String> all = Bell.values.map((e) => e.name).toList();
  all.remove(Bell.none.name);
  all.remove(Bell.random.name);
  return all;
}

List<String> getAllAmbienceToList() {
  List<String> all = Ambience.values.map((e) => e.name).toList();
  all.remove(Ambience.none.name);
  all.remove(Ambience.none.name);
  return all;
}

String getRandomAudio(List<String> randomList) {
  final r = Random().nextInt(randomList.length);
  return randomList[r];
}
