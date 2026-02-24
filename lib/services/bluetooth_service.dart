import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart' as fbp;

class BluetoothService {
  fbp.BluetoothDevice? connectedDevice;
  fbp.BluetoothCharacteristic? writeCharacteristic;

  get characteristics => null;

  Future<List<fbp.ScanResult>> scanDevices() async {
    // Start scan and wait until it finishes, then return accumulated results
    await fbp.FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    await fbp.FlutterBluePlus.isScanning.where((scanning) => scanning == false).first;
    return fbp.FlutterBluePlus.lastScanResults;
  }

  Future<void> connectToDevice(fbp.BluetoothDevice device) async {
    await device.connect();
    connectedDevice = device;

    List<fbp.BluetoothService> services = await device.discoverServices();

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
    connectedDevice = null;
    writeCharacteristic = null;
  }
}
