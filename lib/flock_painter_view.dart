import 'dart:async';
import 'package:flocking_simulation/boid_simulation.dart';
import 'package:flocking_simulation/flock_painter.dart';
import 'package:flutter/material.dart';

class FlockPainterView extends StatefulWidget {
  final void Function() refresh;
  final bool showMenu;
  const FlockPainterView(this.refresh, this.showMenu, {super.key});

  @override
  State<FlockPainterView> createState() => _FlockPainterViewState();
}

class _FlockPainterViewState extends State<FlockPainterView> {
  double _cohesionSlider = 1;
  double _alignSlider = 1;
  double _separationSlider = 1;
  bool _isPaused = false;
  bool _avoidBorder = true;
  final int _updatesPerSecond = 30;

  final flock =
      List<BoidSimulation>.generate(50, (index) => BoidSimulation.newBoid());
  late Timer timer;

  @override
  void initState() {
    super.initState();
    if (flock.isEmpty) {
      timer.cancel();
    } else {
      Duration duration = Duration(milliseconds: 1000 ~/ _updatesPerSecond);
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
    return GestureDetector(
      child: Stack(
        children: [
          GestureDetector(
            onTapDown: (details) {
              final tapPosition = details.globalPosition;
              setState(() {
                flock.add(BoidSimulation.newBoidOnTap(
                    tapPosition.dx, tapPosition.dy));
              });
            },
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
          if (widget.showMenu)
            Opacity(
              opacity: 0.8,
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
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
                                (_isPaused) ? Icons.play_arrow : Icons.pause),
                          ),
                          IconButton(
                            onPressed: widget.refresh,
                            icon: const Icon(Icons.refresh),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                for (var i = 0; i < 10; i++) {
                                  flock.add(BoidSimulation.newBoid());
                                }
                              });
                            },
                            icon: const Icon(Icons.add),
                          ),
                          IconButton(
                            onPressed: (flock.isEmpty)
                                ? null
                                : () {
                                    setState(() {
                                      if (flock.length < 10) {
                                        flock.removeAt(0);
                                      } else {
                                        for (var i = 0; i < 10; i++) {
                                          flock.removeAt(0);
                                        }
                                      }
                                    });
                                  },
                            icon: const Icon(Icons.remove),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(140, 40),
                                  side: const BorderSide(
                                    color: Colors.white,
                                  )),
                              onPressed: () {
                                setState(() {
                                  _avoidBorder = !_avoidBorder;
                                });
                              },
                              child: Text((_avoidBorder)
                                  ? 'Borderless'
                                  : 'Avoid Borders'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FittedBox(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    'Cohesion: $_cohesionSlider',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              FittedBox(
                                fit: BoxFit.fill,
                                child: Slider(
                                  value: _cohesionSlider,
                                  min: 0,
                                  max: 2,
                                  divisions: 20,
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    'Alignment: $_alignSlider',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Slider(
                                  value: _alignSlider,
                                  min: 0,
                                  max: 2,
                                  divisions: 20,
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
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 5.0,
                                  ),
                                  child: Text(
                                    'Separation: $_separationSlider',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ),
                              FittedBox(
                                child: Slider(
                                  value: _separationSlider,
                                  min: 0,
                                  max: 2,
                                  divisions: 20,
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
                        const SizedBox(width: 55, height: 55),
                      ],
                    ),
                  ],
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
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }
}
