import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHandler {

  static Future<bool> userInSession(String token) async {
    final response = await http.get(Uri.parse('http://localhost:8080/api/user/insession'));
    return jsonDecode(response.body);
  }
}