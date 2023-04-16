import 'package:flocking_simulation/flock_painter_view.dart';
import 'package:flutter/material.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Key _stateKey = UniqueKey();
  bool _showMenu = false;

  _refreshFlocking() {
    setState(() {
      _stateKey = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat,
      floatingActionButton: FloatingActionButton.small(
        tooltip: (_showMenu) ? 'Close settings' : 'Show settings',
        onPressed: () {
          setState(() {
            _showMenu = !_showMenu;
          });
        },
        child: const Icon(Icons.settings),
      ),
      body: SafeArea(
        key: _stateKey,
        child: FlockPainterView(_refreshFlocking, _showMenu),
      ),
    );
  }
}
