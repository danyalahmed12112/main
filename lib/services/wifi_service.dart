import 'package:http/http.dart' as http;

class WifiService {
  Future<String> sendCommand(String ip, String command) async {
    try {
      final uri = Uri.http(ip, '/$command');

      final response = await http.get(uri).timeout(const Duration(seconds: 5));

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
