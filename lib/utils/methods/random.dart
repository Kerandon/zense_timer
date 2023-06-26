import 'dart:math';

class RandomClass {
  static Random random = Random();

  static int calculateIntInRange(int min, int max) =>
      min + random.nextInt(max - min);

  static double calculateDoubleInRange(double min, double max) {
    return random.nextDouble() * (max - min) + min;
  }
}
