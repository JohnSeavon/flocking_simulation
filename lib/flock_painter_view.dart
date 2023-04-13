import 'dart:async';
import 'package:flocking_simulation/boid.dart';
import 'package:flocking_simulation/flock_painter.dart';
import 'package:flocking_simulation/utils.dart';
import 'package:flutter/material.dart';

class FlockPainterView extends StatefulWidget {
  final void Function() refresh;
  const FlockPainterView(this.refresh, {super.key});

  @override
  State<FlockPainterView> createState() => _FlockPainterViewState();
}

class _FlockPainterViewState extends State<FlockPainterView> {
  double _cohesionSlider = 0.2;
  double _alignSlider = 0.6;
  double _separationSlider = 0.6;
  bool _isPaused = false;

  final flock = List<Boid>.generate(500, (index) => Boid());
  late Timer timer;

  @override
  void initState() {
    super.initState();
    const duration = Duration(milliseconds: 33);
    timer = Timer.periodic(duration, (timer) {
      if (!_isPaused) {
        setState(() {
          for (var boid in flock) {
            boid.flock(flock, _cohesionSlider, _alignSlider, _separationSlider);
            boid.updatePosition();
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Opacity(
          opacity: 0.5,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Number of particles: ${flock.length}',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 45,
                    height: 45,
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
                  SizedBox(
                    width: 45,
                    height: 45,
                    child: TextButton(
                      onPressed: widget.refresh,
                      child: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Cohesion: $_cohesionSlider',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
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
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Alignment: $_alignSlider',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
                    ),
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
                ],
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'Separation: $_separationSlider',
                      style: Theme.of(context)
                          .textTheme
                          .bodySmall!
                          .copyWith(color: Colors.white),
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
                ],
              ),
            ],
          ),
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
