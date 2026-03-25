import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class LocationService {
  // Pulls the secret key securely from memory, NOT hardcoded
  static String get _apiKey => dotenv.env['POSITIONSTACK_API_KEY'] ?? '';

  static Future<Map<String, double>?> getCoordinates(String address) async {
    if (_apiKey.isEmpty || _apiKey == 'paste_your_key_here') {
      print("CRITICAL: Positionstack API Key missing or invalid in .env");
      return null;
    }

    final url = Uri.parse('http://api.positionstack.com/v1/forward?access_key=$_apiKey&query=${Uri.encodeComponent(address)}');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['data'] != null && data['data'].isNotEmpty) {
          return {
            'lat': data['data'][0]['latitude'],
            'lng': data['data'][0]['longitude'],
          };
        }
      }
    } catch (e) {
      print("Positionstack Error: $e");
    }
    return null;
  }
}
