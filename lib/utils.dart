import 'dart:math';

final rng = Random();

class Utils {
  static double range(double min, double max) =>
      rng.nextDouble() * (max - min) + min;

  static int color() => rng.nextDouble() * 256 ~/ 1;
}
