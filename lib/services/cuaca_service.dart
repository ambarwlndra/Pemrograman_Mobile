import 'dart:convert';
import 'package:http/http.dart' as http;

class CuacaService {
  static Future<Map<String, dynamic>?> fetchCuaca(String kodeWilayah) async {
    final url = Uri.parse('https://api.bmkg.go.id/publik/prakiraan-cuaca?adm4=$kodeWilayah');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      return null;
    }
  }
}
