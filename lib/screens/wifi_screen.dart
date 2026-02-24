import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import 'dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WifiScreen extends StatefulWidget {
  final BluetoothService btService;
  const WifiScreen({super.key, required this.btService});

  @override
  State<WifiScreen> createState() => _WifiScreenState();
}

class _WifiScreenState extends State<WifiScreen> {
  final ssidController = TextEditingController();
  final passController = TextEditingController();
  bool loading = false;

  Future<void> _sendCredentials() async {
    setState(() => loading = true);
    await widget.btService
        .sendWifiCredentials(ssidController.text, passController.text);
    await widget.btService.disconnect();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("esp_ip", "192.168.1.100"); // user can modify later

    setState(() => loading = false);

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (_) => const DashboardScreen(espIp: "192.168.1.100")),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WiFi Setup")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ssidController,
              decoration: const InputDecoration(labelText: "WiFi SSID"),
            ),
            TextField(
              controller: passController,
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: loading ? null : _sendCredentials,
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Send & Restart ESP32"))
          ],
        ),
      ),
    );
  }
}
