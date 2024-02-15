import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<Map<String, dynamic>> fetchData(String path) async {
    final response = await http.get(Uri.parse('$baseUrl/$path'));

    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> postData(String path, Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$path'),
      body: json.encode(data),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to post data');
    }
  }
}
