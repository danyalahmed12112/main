import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';

class BluetoothService {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? writeCharacteristic;

  get characteristics => null;

  Future<List<ScanResult>> scanDevices() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
    return FlutterBluePlus.scanResults.first;
  }

  Future<void> connectToDevice(BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;

    List<BluetoothService> services = [];
    services = (await device.discoverServices()).cast<BluetoothService>();

    for (var service in services) {
      for (var characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          writeCharacteristic = characteristic;
        }
      }
    }
  }

  Future<void> sendWifiCredentials(String ssid, String password) async {
    if (writeCharacteristic != null) {
      String data = "$ssid,$password\n";
      await writeCharacteristic!.write(utf8.encode(data));
    }
  }

  Future<void> disconnect() async {
    await connectedDevice?.disconnect();
  }
}
