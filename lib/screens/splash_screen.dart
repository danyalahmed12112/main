import 'package:flutter/material.dart';
import 'bluetooth_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkMode();
  }

  Future<void> _checkMode() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();
    final ip = prefs.getString("esp_ip");

    if (ip != null) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (_) => DashboardScreen(espIp: ip)));
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const BluetoothScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: const Center(
          child: Text(
            "ESP32 Smart Control",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
