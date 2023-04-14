import 'dart:math';

import 'package:flocking_simulation/utils.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class Boid {
  Boid() {
    width = size.width / ratio;
    height = size.height / ratio;
    final x = Utils.range(0 + 80, width - 80);
    final y = Utils.range(0 + 80, height - 80);
    position = Vector2(x, y);
    final dx = Utils.range(-maxSpeed, maxSpeed);
    final dy = Utils.range(-maxSpeed, maxSpeed);
    velocity = Vector2(dx, dy);
    velocity = setMag(velocity, maxSpeed);
    acceleration = Vector2.zero();
    color = [Utils.color(), Utils.color()];
  }

  final size = WidgetsBinding.instance.window.physicalSize;
  final ratio = WidgetsBinding.instance.window.devicePixelRatio;
  late double width;
  late double height;

  late Vector2 position;
  late Vector2 velocity;
  late Vector2 acceleration;
  final maxSpeed = Utils.range(6, 8);
  late List<int> color;

  final cohesionRadius = 30.0;
  final maxCohesionForce = Utils.range(0.225, 0.275);
  final alignRadius = 30.0;
  final maxAlignForce = Utils.range(0.54, 0.66);
  final separationRadius = 20.0;
  final maxSeparationForce = Utils.range(0.54, 0.66);

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

  borderless() {
    if (position.x > width) {
      position.x = 0;
    } else if (position.x < 0) {
      position.x = width;
    }
    if (position.y > height) {
      position.y = 0;
    } else if (position.y < 0) {
      position.y = height;
    }
  }

  avoidBorders() {
    const border = 50.0;
    var force = (Utils.range(0, 1.5));
    if (position.x > width - border) {
      velocity.x -= force;
    } else if (position.x < 0 + border) {
      velocity.x += force;
    }
    if (position.y > height - border) {
      velocity.y -= force;
    } else if (position.y < 0 + border) {
      velocity.y += force;
    }

    if (position.x > width) {
      position.x = 0;
      position.y = height - position.y;
    } else if (position.x < 0) {
      position.x = width;
      position.y = height - position.y;
    }
    if (position.y > height) {
      position.y = 0;
      position.x = width - position.x;
    } else if (position.y < 0) {
      position.y = height;
      position.x = width - position.x;
    }
  }

  updatePosition(bool avoidBorder) {
    (avoidBorder) ? avoidBorders() : borderless();
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
