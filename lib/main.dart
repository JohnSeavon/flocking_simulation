import 'package:flocking_simulation/app_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSwatch(),
        sliderTheme: SliderThemeData(
          inactiveTrackColor: Colors.grey[800],
        ),
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: Colors.white,
            highlightColor: Colors.blue[900],
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Colors.blue.withOpacity(0.2),
          foregroundColor: Colors.white54,
          hoverColor: Colors.blue.withOpacity(0.6),
        ),
      ),
      home: const AppWidget(),
    );
  }
}
