import 'dart:math';

import 'package:flocking_simulation/boid_simulation.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class FlockPaint extends CustomPaint {
  @override
  final CustomPainter painter;

  const FlockPaint({super.key, required this.painter});
}

class FlockPainter extends CustomPainter {
  List<BoidSimulation> flock;
  FlockPainter(this.flock);
  static const double boidSize = 8;
  static const halfSize = boidSize / 2;
  static const radius = 2.0;
  @override
  void paint(Canvas canvas, Size size) {
    for (var boid in flock) {
      final randompaint = Paint()
        ..color = Color.fromRGBO(boid.color[0], boid.color[1], 255, 1);

      if (!boid.boid.position.isNaN) {
        canvas.save();
        canvas.translate(boid.boid.position.x, boid.boid.position.y);

        final path = Path()
          ..moveTo(halfSize + 2, 0)
          ..lineTo(-halfSize - 1, halfSize - 2)
          ..lineTo(-halfSize - 1, -halfSize + 2)
          ..close();

        if (boid.boid.velocity != vector.Vector2.zero() &&
            !boid.boid.velocity.isNaN) {
          final boidAngle = atan2(boid.boid.velocity.y, boid.boid.velocity.x);
          canvas.rotate(boidAngle);
        }

        canvas.drawPath(path, randompaint);
        canvas.restore();
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
