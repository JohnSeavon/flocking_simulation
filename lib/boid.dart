import 'package:flocking_simulation/utils.dart';
import 'package:vector_math/vector_math.dart';

class Boid {
  Boid() {
    position = Vector2(500, 500);
    dx = Utils.range(-0.1, 0.1);
    dy = Utils.range(-0.1, 0.1);
    color = [Utils.color(), Utils.color(), Utils.color()];
  }

  late Vector2 position;
  late double dx;
  late double dy;
  late List<int> color;

  updatePosition() {
    if (position.storage[0] > 1000 || position.storage[0] < 0) {
      updatedx();
    }
    if (position.storage[1] > 1000 || position.storage[1] < 0) {
      updatedy();
    }
    position += Vector2(dx, dy);
  }

  updatedx() {
    dx = dx * -1;
  }

  updatedy() {
    dy = dy * -1;
  }
}
