import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';
import '../services/wifi_service.dart';

class DashboardScreen extends StatefulWidget {
  final BluetoothService btService;

  const DashboardScreen(
      {super.key, required this.btService, required String espIp});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final WifiService wifiService = WifiService();

  bool ledOn = false;
  bool wifiMode = false;

  String espIp = "192.168.1.100";

  final ssid = TextEditingController();
  final pass = TextEditingController();

  Future<void> control(String cmd) async {
    try {
      if (wifiMode) {
        await wifiService.sendCommand(espIp, cmd);
      } else {
        await widget.btService.sendLedCommand(cmd);
      }

      setState(() => ledOn = cmd == "on");
    } catch (_) {
      wifiMode = false;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("WiFi Lost → Switched to Bluetooth"),
        ),
      );
    }
  }

  void wifiDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("WiFi Setup"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: ssid,
              decoration: const InputDecoration(labelText: "SSID"),
            ),
            TextField(
              controller: pass,
              decoration: const InputDecoration(labelText: "Password"),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await widget.btService.sendWifiCredentials(ssid.text, pass.text);

              setState(() => wifiMode = true);

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Now controlling via WiFi"),
              ));
            },
            child: const Text("Connect"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ESP32 Dashboard"),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: wifiDialog,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.teal],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Chip(
                label: Text(wifiMode ? "WiFi Mode" : "Bluetooth Mode"),
              ),
              const SizedBox(height: 40),
              AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ledOn ? Colors.green : Colors.red,
                  boxShadow: [
                    BoxShadow(
                      color: ledOn ? Colors.green : Colors.red,
                      blurRadius: 40,
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                  onPressed: () => control("on"), child: const Text("LED ON")),
              ElevatedButton(
                  onPressed: () => control("off"),
                  child: const Text("LED OFF")),
            ],
          ),
        ),
      ),
    );
  }
}
