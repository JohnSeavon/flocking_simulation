import 'dart:math';

final rng = Random();

class Utils {
  static double range(double min, double max) =>
      rng.nextDouble() * (max - min) + min;

  static int color() => rng.nextInt(105) + 100;

  static const width = 1000.0;
  static const height = 1000.0;
}
