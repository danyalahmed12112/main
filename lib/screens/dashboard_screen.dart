import 'package:flutter/material.dart';
import '../services/wifi_service.dart';

class DashboardScreen extends StatefulWidget {
  final String espIp;
  const DashboardScreen({super.key, required this.espIp});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WifiService wifiService = WifiService();
  bool ledOn = false;
  bool connected = true;

  Future<void> _control(String command) async {
    try {
      final response = await wifiService.sendCommand(widget.espIp, command);

      setState(() {
        ledOn = command == "on";
        connected = true;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(response)));
    } catch (e) {
      setState(() => connected = false);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("WiFi Failed. Switch to Bluetooth.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ESP32 Dashboard")),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.black, Colors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: ledOn ? Colors.green : Colors.red,
                boxShadow: [
                  BoxShadow(
                    color: (ledOn ? Colors.green : Colors.red).withOpacity(0.8),
                    blurRadius: 40,
                    spreadRadius: 10,
                  )
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text("IP: ${widget.espIp}"),
            Text(connected ? "Connected" : "Not Connected"),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => _control("on"), child: const Text("LED ON")),
            ElevatedButton(
                onPressed: () => _control("off"), child: const Text("LED OFF")),
          ],
        ),
      ),
    );
  }
}
