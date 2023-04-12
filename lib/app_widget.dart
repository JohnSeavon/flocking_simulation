import 'dart:async';
import 'package:flocking_simulation/boid.dart';
import 'package:flocking_simulation/flock_painter.dart';
import 'package:flocking_simulation/utils.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final flock = List<Boid>.generate(100, (index) => Boid());
  late Timer timer;
  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 33);
    timer = Timer.periodic(duration, (timer) {
      setState(() {
        for (var boid in flock) {
          boid.flock(flock);
          boid.updatePosition();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
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
                width: Utils.width,
                height: Utils.height,
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
                width: Utils.width,
                height: Utils.height,
                child: FlockPaint(
                  painter: FlockPainter(flock),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
