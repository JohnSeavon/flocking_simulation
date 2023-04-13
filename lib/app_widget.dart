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
  double _alignSlider = 1.0;
  double _cohesionSlider = 0.2;
  double _separationSlider = 0.6;
  bool _isPaused = false;

  final flock = List<Boid>.generate(200, (index) => Boid());
  late Timer timer;
  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 33);
    timer = Timer.periodic(duration, (timer) {
      if (!_isPaused) {
        setState(() {
          for (var boid in flock) {
            boid.flock(flock, _alignSlider, _cohesionSlider, _separationSlider);
            boid.updatePosition();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Text(
                  'Number of particles: ${flock.length}',
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(color: Colors.white),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Slider(
                    value: _alignSlider,
                    min: 0,
                    max: 2,
                    divisions: 10,
                    onChanged: ((double value) {
                      setState(() {
                        _alignSlider = value;
                      });
                    }),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Slider(
                    value: _cohesionSlider,
                    min: 0,
                    max: 2,
                    divisions: 10,
                    onChanged: ((double value) {
                      setState(() {
                        _cohesionSlider = value;
                      });
                    }),
                  ),
                ),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Slider(
                    value: _separationSlider,
                    min: 0,
                    max: 2,
                    divisions: 10,
                    onChanged: ((double value) {
                      setState(() {
                        _separationSlider = value;
                      });
                    }),
                  ),
                ),
                SizedBox(
                  width: 50,
                  height: 25,
                  child: TextButton(
                    onPressed: () {
                      setState(() {
                        _isPaused = !_isPaused;
                      });
                    },
                    child: Icon(
                      (_isPaused) ? Icons.play_arrow : Icons.pause,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            IgnorePointer(
              child: Center(
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
            ),
            IgnorePointer(
              child: Center(
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
            ),
          ],
        ),
      ),
    );
  }
}
