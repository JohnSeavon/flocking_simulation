import 'package:vector_math/vector_math.dart';

class Boid {
  late Vector2 position;
  late Vector2 velocity;
  late Vector2 acceleration;
  Boid({
    required this.position,
    required this.velocity,
    required this.acceleration,
  });
}
