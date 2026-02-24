import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp hide BluetoothService;
import 'package:permission_handler/permission_handler.dart';

import '../services/bluetooth_service.dart';
import 'wifi_screen.dart';

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final BluetoothService btService = BluetoothService();
  List<fbp.ScanResult> devices = [];
  bool scanning = false;

  Future<void> _requestPermissions() async {
    await [
      Permission.bluetooth,
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
      Permission.locationWhenInUse,
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
      appBar: AppBar(
        title: const Text("Select ESP32 Device"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: scanning ? null : _scan,
            tooltip: 'Scan again',
          ),
        ],
      ),
      body: scanning
          ? const Center(child: CircularProgressIndicator())
          : devices.isEmpty
              ? const Center(child: Text("No devices found. Tap scan to retry."))
              : ListView(
                  children: devices.map((d) {
                    final name = d.device.platformName.isNotEmpty ? d.device.platformName : d.device.remoteId.toString();
                    final isEsp32 = d.device.platformName.toLowerCase().contains('esp32');
                    return ListTile(
                      leading: Icon(
                        Icons.bluetooth,
                        color: isEsp32 ? Colors.blue : Colors.grey,
                      ),
                      title: Text(name),
                      subtitle: Text('${d.device.remoteId}  •  RSSI: ${d.rssi} dBm'),
                      onTap: () async {
                        await btService.connectToDevice(d.device);
                        if (context.mounted) {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => WifiScreen(btService: btService)));
                        }
                      },
                    );
                  }).toList(),
                ),
    );
  }
}
