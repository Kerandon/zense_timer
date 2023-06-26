import '../models/bell_random.dart';

const List<int> countdownTimes = [0, 5000, 10000, 15000, 20000, 30000, 60000];
const List<int> possibleBellTimes = [
  30000,
  60000,
  120000,
  180000,
  300000,
  600000,
  900000,
  1800000
];
const List<BellRandom> randomBells = [
  BellRandom(0, 30000, 60000),
  BellRandom(1, 60000, 120000),
  BellRandom(2, 120000, 300000),
  BellRandom(3, 300000, 600000),
  BellRandom(4, 600000, 1200000),
  BellRandom(5, 900000, 1800000),
];
