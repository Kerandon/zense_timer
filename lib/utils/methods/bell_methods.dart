import 'dart:math';

import '../../enums/bell.dart';

List<String> getAllBellsToList() {
  List<String> allBells = Bell.values.map((e) => e.name).toList();
  allBells.remove(Bell.none.name);
  allBells.remove(Bell.random.name);
  return allBells;
}

String getRandomBell(List<String> randomBells) {
  final r = Random().nextInt(randomBells.length);
  return randomBells[r];
}
