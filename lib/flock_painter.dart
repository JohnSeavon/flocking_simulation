import 'dart:math';

import 'package:flocking_simulation/boid.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart' as vector;

class FlockPaint extends CustomPaint {
  @override
  final CustomPainter painter;

  const FlockPaint({super.key, required this.painter});
}

class FlockPainter extends CustomPainter {
  List<Boid> flock;
  FlockPainter(this.flock);
  static const double boidSize = 8;
  static const halfSize = boidSize / 2;
  static const radius = 2.0;
  @override
  void paint(Canvas canvas, Size size) {
    final paintCenter = Paint()..color = Colors.white30;
    //final paint = Paint()..color = Colors.white;

    // final paintCircle = Paint()
    //   ..color = Colors.white10
    //   ..style = PaintingStyle.stroke;

    // final paintCircleRed = Paint()
    //   ..color = Colors.red.withOpacity(0.2)
    //   ..style = PaintingStyle.stroke;

    canvas.drawCircle(Offset(size.width / 2, size.height / 2), 1, paintCenter);

    for (var boid in flock) {
      final randompaint = Paint()
        ..color = Color.fromRGBO(boid.color[0], boid.color[1], 255, 1);

      if (!boid.position.isNaN) {
        canvas.save();
        canvas.translate(boid.position.x, boid.position.y);

        final path = Path()
          ..moveTo(halfSize + 2, 0)
          ..lineTo(-halfSize - 1, halfSize - 2)
          ..lineTo(-halfSize - 1, -halfSize + 2)
          ..close();

        if (boid.velocity != vector.Vector2.zero() && !boid.velocity.isNaN) {
          final boidAngle = atan2(boid.velocity.y, boid.velocity.x);
          canvas.rotate(boidAngle);
        }

        canvas.drawPath(path, randompaint);
        canvas.restore();

        //   // perception radius
        //   canvas.drawCircle(
        //       Offset(boid.position.x, boid.position.y), 40, paintCircle);
        //   // separation radius
        //   canvas.drawCircle(
        //       Offset(boid.position.x, boid.position.y), 15, paintCircleRed);
        // } else {
        //   debugPrint('NaN');
        // }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
