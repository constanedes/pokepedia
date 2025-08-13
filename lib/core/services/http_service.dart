// lib/core/services/http_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpService {
  final http.Client client;

  HttpService({http.Client? client}) : client = client ?? http.Client();

  Future<Map<String, dynamic>> get(String url) async {
    final response = await client.get(Uri.parse(url));

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error HTTP ${response.statusCode}: ${response.body}");
    }
  }
}
