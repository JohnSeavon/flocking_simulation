import 'dart:math';

final rng = Random();

class Utils {
  static double range(double min, double max) =>
      rng.nextDouble() * (max - min) + min;

  static int color() => rng.nextDouble() * 256 ~/ 1;

  static double rangebool(double min, double max) =>
      (rng.nextBool() ? 0.8 : 0.2) * (max - min) + min;
}
