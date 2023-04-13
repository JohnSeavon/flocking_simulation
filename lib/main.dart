import 'package:flocking_simulation/app_widget.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(),
          sliderTheme: SliderThemeData(
            inactiveTrackColor: Colors.grey[800],
          )),
      home: const AppWidget(),
    );
  }
}
