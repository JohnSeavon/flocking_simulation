import 'dart:async';
import 'package:flocking_simulation/boid.dart';
import 'package:flocking_simulation/flock_painter.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final flock = List<Boid>.generate(1000, (index) => Boid());
  late Timer timer;
  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 100 ~/ 60);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        for (var boid in flock) {
          boid.updatePosition();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Text(
          'Number of particles: ${flock.length}',
          style: Theme.of(context)
              .textTheme
              .bodySmall!
              .copyWith(color: Colors.white),
        ),
        Center(
          child: FittedBox(
            child: Container(
              height: 1000,
              width: 1000,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
            ),
          ),
        ),
        Center(
          child: FittedBox(
            child: SizedBox(
              height: 1000,
              width: 1000,
              child: FlockPaint(
                painter: FlockPainter(flock),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
