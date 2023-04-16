import 'dart:math';

import 'package:flocking_simulation/boid.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

import 'package:flocking_simulation/utils.dart';

class BoidSimulation {
  BoidSimulation.newBoid() {
    width = size.width / ratio;
    height = size.height / ratio;
    final x = Utils.range(0, width);
    final y = Utils.range(0, height);
    final dx = Utils.range(-maxSpeed, maxSpeed);
    final dy = Utils.range(-maxSpeed, maxSpeed);
    var velocity = Vector2(dx, dy);
    velocity = setMag(velocity, maxSpeed);
    color = [Utils.color(), Utils.color()];
    boid = Boid(
      position: Vector2(x, y),
      velocity: velocity,
      acceleration: Vector2.zero(),
    );
  }

  BoidSimulation.newBoidOnTap(double x, double y) {
    width = size.width / ratio;
    height = size.height / ratio;
    final dx = Utils.range(-maxSpeed, maxSpeed);
    final dy = Utils.range(-maxSpeed, maxSpeed);
    var velocity = Vector2(dx, dy);
    velocity = setMag(velocity, maxSpeed);
    color = [Utils.color(), Utils.color()];
    boid = Boid(
      position: Vector2(x, y),
      velocity: velocity,
      acceleration: Vector2.zero(),
    );
  }

  final size = WidgetsBinding.instance.window.physicalSize;
  final ratio = WidgetsBinding.instance.window.devicePixelRatio;
  late double width;
  late double height;

  late Boid boid;
  final maxSpeed = Utils.range(6, 8);
  late List<int> color;

  final cohesionRadius = 30.0;
  final maxCohesionForce = Utils.range(0.247, 0.302);
  final alignRadius = 30.0;
  final maxAlignForce = Utils.range(0.486, 0.594);
  final separationRadius = 20.0;
  final maxSeparationForce = Utils.range(0.486, 0.594);

  Vector2 cohesion(List<BoidSimulation> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = boid.position.distanceTo(other.boid.position);
      if (other != this && d < cohesionRadius) {
        steering.add(other.boid.position);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering.sub(boid.position);
      steering = setMag(steering, maxSpeed);
      steering.sub(boid.velocity);
      steering = limit(steering, maxCohesionForce);
    }
    return steering;
  }

  Vector2 align(List<BoidSimulation> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = boid.position.distanceTo(other.boid.position);
      if (other != this && d < alignRadius) {
        steering.add(other.boid.velocity);
        total++;
      }
    }
    if (total > 0) {
      steering /= ((total).toDouble());
      steering = setMag(steering, maxSpeed);
      steering.sub(boid.velocity);
      steering = limit(steering, maxAlignForce);
    }
    return steering;
  }

  Vector2 separation(List<BoidSimulation> boids) {
    Vector2 steering = Vector2.zero();
    int total = 0;
    for (var other in boids) {
      final d = boid.position.distanceTo(other.boid.position);
      if (other != this && d < separationRadius) {
        Vector2 diff = Vector2(boid.position.x, boid.position.y);
        diff.sub(other.boid.position);
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
      steering.sub(boid.velocity);
      steering = limit(steering, maxSeparationForce);
    }
    return steering;
  }

  flock(
    List<BoidSimulation> boids,
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

    boid.acceleration.add(cohesion);
    boid.acceleration.add(alignment);
    boid.acceleration.add(separation);
  }

  borderless() {
    if (boid.position.x > width) {
      boid.position.x = 0;
    } else if (boid.position.x < 0) {
      boid.position.x = width;
    }
    if (boid.position.y > height) {
      boid.position.y = 0;
    } else if (boid.position.y < 0) {
      boid.position.y = height;
    }
  }

  avoidBorders() {
    const border = 50.0;
    var force = (Utils.range(0, 1.5));
    if (boid.position.x > width - border) {
      boid.velocity.x -= force;
    } else if (boid.position.x < 0 + border) {
      boid.velocity.x += force;
    }
    if (boid.position.y > height - border) {
      boid.velocity.y -= force;
    } else if (boid.position.y < 0 + border) {
      boid.velocity.y += force;
    }

    if (boid.position.x > width) {
      boid.position.x = 0;
      boid.position.y = height - boid.position.y;
    } else if (boid.position.x < 0) {
      boid.position.x = width;
      boid.position.y = height - boid.position.y;
    }
    if (boid.position.y > height) {
      boid.position.y = 0;
      boid.position.x = width - boid.position.x;
    } else if (boid.position.y < 0) {
      boid.position.y = height;
      boid.position.x = width - boid.position.x;
    }
  }

  updatePosition(bool avoidBorder) {
    (avoidBorder) ? avoidBorders() : borderless();
    boid.position.add(boid.velocity);
    boid.velocity.add(boid.acceleration);
    boid.velocity = limit(boid.velocity, maxSpeed);
    boid.acceleration.setZero();
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
