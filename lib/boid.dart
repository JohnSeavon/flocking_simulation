import 'dart:math';

import 'package:flocking_simulation/utils.dart';
import 'package:vector_math/vector_math.dart';

class Boid {
  Boid() {
    final x = Utils.range(0, Utils.width);
    final y = Utils.range(0, Utils.height);
    position = Vector2(x, y);
    final dx = Utils.range(-4, 4);
    final dy = Utils.range(-4, 4);
    velocity = Vector2(dx, dy);
    velocity = setMag(velocity, Utils.range(2, 4));
    acceleration = Vector2.zero();
    maxForce = 1;
    maxSpeed = 4;
    color = [Utils.color(), Utils.color(), Utils.color()];
  }

  late Vector2 position;
  late Vector2 velocity;
  late Vector2 acceleration;
  late double maxForce;
  late double maxSpeed;
  late List<int> color;

  Vector2 align(List<Boid> boids) {
    const perceptionRadius = 50.0;
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < perceptionRadius) {
        steering.add(other.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxForce);
    }
    return steering;
  }

  Vector2 separation(List<Boid> boids) {
    const perceptionRadius = 50.0;
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < perceptionRadius) {
        Vector2 diff = Vector2(position.x, position.y);
        diff.sub(other.position);
        if (d != 0) {
          diff /= d;
        } else {
          diff /= 0.1;
        }
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxForce);
    }
    return steering;
  }

  Vector2 cohesion(List<Boid> boids) {
    const perceptionRadius = 50.0;
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < perceptionRadius) {
        steering.add(other.position);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering.sub(position);
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxForce);
    }
    return steering;
  }

  flock(
    List<Boid> boids,
    double alignValue,
    double cohesionValue,
    double separationValue,
  ) {
    Vector2 alignment = align(boids);
    Vector2 cohesion = this.cohesion(boids);
    Vector2 separation = this.separation(boids);

    alignment.scale(alignValue);
    cohesion.scale(cohesionValue);
    separation.scale(separationValue);

    acceleration.add(separation);
    acceleration.add(alignment);
    acceleration.add(cohesion);
  }

  updatePosition() {
    if (position.x > Utils.width) {
      position.x = 0;
    } else if (position.x < 0) {
      position.x = Utils.width;
    }
    if (position.y > Utils.height) {
      position.y = 0;
    } else if (position.y < 0) {
      position.y = Utils.height;
    }
    position.add(velocity);
    velocity.add(acceleration);
    velocity = limit(velocity, maxSpeed);
    acceleration.setZero();
  }

  Vector2 setMag(Vector2 newVector, double len) {
    double mag = len / newVector.length;
    newVector.x *= mag;
    newVector.y *= mag;
    return newVector;
  }

  Vector2 limit(Vector2 newVector, double max) {
    final mSq = newVector.length2;
    if (mSq > (max * max)) {
      newVector /= sqrt(mSq);
      newVector *= max;
    }
    return newVector;
  }
}
