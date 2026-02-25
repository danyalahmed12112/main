import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  BluetoothDevice? device;
  BluetoothCharacteristic? writeChar;

  final Guid serviceUuid = Guid("12345678-1234-1234-1234-1234567890ab");

  final Guid charUuid = Guid("abcd1234-5678-1234-5678-1234567890ab");

  Future<List<ScanResult>> scanDevices() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));

    await FlutterBluePlus.isScanning.where((s) => s == false).first;

    return FlutterBluePlus.lastScanResults;
  }

  Future<void> connectToDevice(BluetoothDevice d) async {
    device = d;

    await d.connect();

    var services = await d.discoverServices();

    for (var s in services) {
      if (s.uuid == serviceUuid) {
        for (var c in s.characteristics) {
          if (c.uuid == charUuid) {
            writeChar = c;
          }
        }
      }
    }
  }

  Future<void> sendLedCommand(String cmd) async {
    if (writeChar == null) return;

    await writeChar!.write(utf8.encode("LED:$cmd\n"));
  }

  Future<void> sendWifiCredentials(String ssid, String pass) async {
    if (writeChar == null) return;

    await writeChar!.write(utf8.encode("WIFI:$ssid,$pass\n"));
  }

  Future<void> disconnect() async {}
}
