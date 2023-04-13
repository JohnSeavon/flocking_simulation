import 'package:flocking_simulation/flock_painter_view.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Key _stateKey = UniqueKey();

  _refreshFlocking() {
    setState(() {
      _stateKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        key: _stateKey,
        child: FlockPainterView(_refreshFlocking),
      ),
    );
  }
}
