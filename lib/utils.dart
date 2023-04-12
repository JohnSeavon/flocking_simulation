import 'dart:math';

final rng = Random();

class Utils {
  static double range(double min, double max) =>
      rng.nextDouble() * (max - min) + min;

  static int color() => rng.nextDouble() * 256 ~/ 1;

  static const width = 640.0;
  static const height = 360.0;
}
