import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' hide BluetoothService;
import '../services/bluetooth_service.dart';
import 'wifi_screen.dart';
import 'package:permission_handler/permission_handler.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothService btService = BluetoothService();
  List<ScanResult> devices = [];
  bool scanning = false;

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location
    ].request();
  }

  Future<void> _scan() async {
    await _requestPermissions();
    setState(() => scanning = true);
    devices = await btService.scanDevices();
    setState(() => scanning = false);
  }

  @override
  void initState() {
    super.initState();
    _scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Select ESP32 Device")),
      body: scanning
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: devices
                  .where((d) => d.device.name == "ESP32_Config_Mode")
                  .map((d) => ListTile(
                        title: Text(d.device.name),
                        subtitle: Text(d.device.id.toString()),
                        onTap: () async {
                          await btService.connectToDevice(d.device);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) =>
                                      WifiScreen(btService: btService)));
                        },
                      ))
                  .toList(),
            ),
    );
  }
}
