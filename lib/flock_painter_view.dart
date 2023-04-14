import 'dart:async';
import 'package:flocking_simulation/boid.dart';
import 'package:flocking_simulation/flock_painter.dart';
import 'package:flutter/material.dart';

class FlockPainterView extends StatefulWidget {
  final void Function() refresh;
  const FlockPainterView(this.refresh, {super.key});

  @override
  State<FlockPainterView> createState() => _FlockPainterViewState();
}

class _FlockPainterViewState extends State<FlockPainterView> {
  double _cohesionSlider = 1;
  double _alignSlider = 1;
  double _separationSlider = 1;
  bool _isPaused = false;
  bool _avoidBorder = true;

  final flock = List<Boid>.generate(50, (index) => Boid());
  late Timer timer;

  @override
  void initState() {
    super.initState();
    if (flock.isEmpty) {
      timer.cancel();
    } else {
      const duration = Duration(milliseconds: 33);
      timer = Timer.periodic(duration, (timer) {
        if (!_isPaused) {
          setState(() {
            for (var boid in flock) {
              boid.flock(
                  flock, _cohesionSlider, _alignSlider, _separationSlider);
              boid.updatePosition(_avoidBorder);
            }
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        width: 150,
                        child: Text(
                          'Number of boids: ${flock.length}',
                          style: Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _isPaused = !_isPaused;
                          });
                        },
                        icon: Icon(
                          (_isPaused) ? Icons.play_arrow : Icons.pause,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: widget.refresh,
                        icon: const Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            for (var i = 0; i < 10; i++) {
                              flock.add(Boid());
                            }
                          });
                        },
                        icon: const Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                      ),
                      IconButton(
                        onPressed: (flock.isEmpty)
                            ? null
                            : () {
                                setState(() {
                                  for (var i = 0; i < 10; i++) {
                                    flock.removeAt(0);
                                  }
                                });
                              },
                        icon: const Icon(
                          Icons.remove,
                          color: Colors.white,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size(140, 40),
                              side: const BorderSide(
                                color: Colors.white,
                                width: 0.5,
                              )),
                          onPressed: () {
                            setState(() {
                              _avoidBorder = !_avoidBorder;
                            });
                          },
                          child: Text(
                              (_avoidBorder) ? 'Bordeless' : 'Avoid Borders'),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'Cohesion: $_cohesionSlider',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          FittedBox(
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
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'Alignment: $_alignSlider',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          FittedBox(
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
                        ],
                      ),
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FittedBox(
                            child: Text(
                              'Separation: $_separationSlider',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                          FittedBox(
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
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        IgnorePointer(
          child: Center(
            child: FittedBox(
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: FlockPaint(
                  painter: FlockPainter(flock),
                ),
              ),
            ),
          ),
        ),
        if (_isPaused)
          Center(
            child: Text(
              'Paused',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          )
      ],
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
