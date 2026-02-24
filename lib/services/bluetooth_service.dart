import 'dart:convert';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  BluetoothDevice? connectedDevice;
  BluetoothCharacteristic? writeCharacteristic;

  // 🔥 MUST MATCH ESP32 UUID
  final Guid serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");

  final Guid characteristicUuid = Guid("abcd1234-5678-1234-5678-1234567890ab");

  get uuid => null;

  get characteristics => null;

  /// 🔍 Scan Devices
  Future<List<ScanResult>> scanDevices() async {
    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    await FlutterBluePlus.isScanning.where((scanning) => scanning == false).first;

    return FlutterBluePlus.lastScanResults;
  }

  /// 🔗 Connect
  Future<void> connectToDevice(BluetoothDevice device) async {
    connectedDevice = device;

    await device.connect(autoConnect: false);

    final services = await device.discoverServices();

    for (var service in services) {
      if (service.uuid == serviceUuid) {
        for (var characteristic in service.characteristics) {
          if (characteristic.uuid == characteristicUuid) {
            writeCharacteristic = characteristic;
          }
        }
      }
    }

    if (writeCharacteristic == null) {
      throw Exception("Write characteristic not found!");
    }
  }

  /// 📶 Send WiFi Credentials
  Future<void> sendWifiCredentials(String ssid, String password) async {
    if (writeCharacteristic == null) {
      throw Exception("Device not connected");
    }

    String data = "WIFI:$ssid,$password\n";

    await writeCharacteristic!.write(
      utf8.encode(data),
      withoutResponse: false,
    );
  }

  /// ❌ Disconnect
  Future<void> disconnect() async {
    await connectedDevice?.disconnect();
    connectedDevice = null;
    writeCharacteristic = null;
  }
}
