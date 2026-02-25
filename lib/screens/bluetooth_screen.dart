import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;
import 'package:permission_handler/permission_handler.dart';

import '../services/bluetooth_service.dart';
import 'dashboard_screen.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothService btService = BluetoothService();

  List<fbp.ScanResult> devices = [];
  bool scanning = false;

  Future<void> requestPermission() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  Future<void> scan() async {
    await requestPermission();

    setState(() => scanning = true);

    devices = await btService.scanDevices();

    setState(() => scanning = false);
  }

  @override
  void initState() {
    super.initState();
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select ESP32")),
      body: scanning
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: devices.map((d) {
                return ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(
                    d.device.platformName.isEmpty
                        ? d.device.remoteId.toString()
                        : d.device.platformName,
                  ),
                  subtitle: Text("RSSI: ${d.rssi}"),
                  onTap: () async {
                    await btService.connectToDevice(d.device);

                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DashboardScreen(btService: btService, espIp: '',),
                        ),
                      );
                    }
                  },
                );
              }).toList(),
            ),
    );
  }
}
