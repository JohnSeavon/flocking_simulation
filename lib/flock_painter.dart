import 'package:flocking_simulation/boid.dart';
import 'package:flutter/material.dart';

class FlockPaint extends CustomPaint {
  @override
  final CustomPainter painter;

  const FlockPaint({super.key, required this.painter});
}

class FlockPainter extends CustomPainter {
  List<Boid> flock;
  FlockPainter(this.flock);
  @override
  void paint(Canvas canvas, Size size) {
    const radius = 2.0;
    final List<double> position = [size.width / 2, size.height / 2];
    final paintCenter = Paint()..color = Colors.white30;
    final paintCircle = Paint()
      ..color = Colors.white10
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(Offset(position[0], position[1]), 1, paintCenter);

    for (var boid in flock) {
      final randompaint = Paint()
        ..color =
            Color.fromRGBO(boid.color[0], boid.color[1], boid.color[2], 1);
      if (!boid.position.isNaN) {
        canvas.drawCircle(
          Offset(
            boid.position.x,
            boid.position.y,
          ),
          radius,
          randompaint,
        );
        // canvas.drawCircle(
        //   Offset(
        //     boid.position.x,
        //     boid.position.y,
        //   ),
        //   15,
        //   paintCircle,
        // );
      } else {
        debugPrint('NaN');
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
