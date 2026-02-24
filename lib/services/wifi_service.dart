import 'package:http/http.dart' as http;

class WifiService {
  Future<String> sendCommand(String ip, String command) async {
    try {
      final response = await http.get(Uri.parse("http://$ip/$command")).timeout(
            const Duration(seconds: 5),
          );

      if (response.statusCode == 200) {
        return response.body;
      } else {
        return "Error: ${response.statusCode}";
      }
    } catch (e) {
      throw Exception("WiFi Connection Failed");
    }
  }
}
