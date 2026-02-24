import 'dart:developer';

import 'package:http/http.dart' as http;

class WifiService {
  Future<String> sendCommand(String ip, String command) async {
    try {
      final uri = Uri.http(ip, '/$command');
      log("Sending command: $command to $ip, this is the url of calling $uri");
      final response = await http.get(uri).timeout(const Duration(seconds: 5));
      log("Sent command: $command to $ip, got status: ${response.statusCode} this is the url of calling $uri");
      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      return "WiFi Connection Failed";
    }
  }
}
