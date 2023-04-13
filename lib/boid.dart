import 'dart:math';

import 'package:flocking_simulation/utils.dart';
import 'package:vector_math/vector_math.dart';

class Boid {
  Boid() {
    final x = Utils.range(0, Utils.width);
    final y = Utils.range(0, Utils.height);
    position = Vector2(x, y);
    final dx = Utils.range(-5, 5);
    final dy = Utils.range(-5, 5);
    velocity = Vector2(dx, dy);
    velocity = setMag(velocity, Utils.range(3, 5));
    acceleration = Vector2.zero();
    //maxForce = 1;
    maxSpeed = 5;
    color = [Utils.color(), Utils.color()];
  }

  late Vector2 position;
  late Vector2 velocity;
  late Vector2 acceleration;
  //late double maxForce;
  late double maxSpeed;
  late List<int> color;

  final cohesionRadius = 40.0;
  final maxCohesionForce = 0.8;
  final alignRadius = 40.0;
  final maxAlignForce = 1.1;
  final separationRadius = 20.0;
  final maxSeparationForce = 0.7;

  Vector2 cohesion(List<Boid> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < cohesionRadius) {
        steering.add(other.position);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering.sub(position);
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxCohesionForce);
    }
    return steering;
  }

  Vector2 align(List<Boid> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < alignRadius) {
        steering.add(other.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxAlignForce);
    }
    return steering;
  }

  Vector2 separation(List<Boid> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = position.distanceTo(other.position);
      if (other != this && d < separationRadius) {
        Vector2 diff = Vector2(position.x, position.y);
        diff.sub(other.position);
        if (d != 0) {
          diff /= (d * d);
        } else {
          diff /= 0.0001;
        }
        steering.add(diff);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering = setMag(steering, maxSpeed);
      steering.sub(velocity);
      steering = limit(steering, maxSeparationForce);
    }
    return steering;
  }

  flock(
    List<Boid> boids,
    double cohesionValue,
    double alignValue,
    double separationValue,
  ) {
    Vector2 cohesion = this.cohesion(boids);
    Vector2 alignment = align(boids);
    Vector2 separation = this.separation(boids);

    cohesion.scale(cohesionValue);
    alignment.scale(alignValue);
    separation.scale(separationValue);

    acceleration.add(cohesion);
    acceleration.add(alignment);
    acceleration.add(separation);
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
