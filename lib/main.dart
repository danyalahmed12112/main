import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const ESP32SmartControl());
}

class ESP32SmartControl extends StatelessWidget {
  const ESP32SmartControl({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP32 Smart Control',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.teal,
      ),
      home: const SplashScreen(),
    );
  }
}
