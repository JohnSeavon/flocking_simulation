import 'package:flocking_simulation/utils.dart';
import 'package:vector_math/vector_math.dart';

class Boid {
  Boid() {
    position = Vector2(500, 500);
    velocity = Vector2(Utils.range(-0.1, 0.1), Utils.range(-0.1, 0.1));
    acceleration = Vector2.zero();

    color = [Utils.color(), Utils.color(), Utils.color()];
  }

  late Vector2 position;
  late Vector2 velocity;
  late Vector2 acceleration;

  late List<int> color;

  updatePosition() {
    if (position.storage[0] > 1000 || position.storage[0] < 0) {
      updatedx();
    }
    if (position.storage[1] > 1000 || position.storage[1] < 0) {
      updatedy();
    }
    position.add(velocity);
    velocity.add(acceleration);
  }

  updatedx() {
    velocity.r = velocity.r * -1;
  }

  updatedy() {
    velocity.g = velocity.g * -1;
  }
}
