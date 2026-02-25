import 'package:http/http.dart' as http;

class WifiService {
  Future<void> sendCommand(String ip, String cmd) async {
    final uri = Uri.http(ip, '/$cmd');

    await http.get(uri).timeout(
          const Duration(seconds: 5),
        );
  }
}
