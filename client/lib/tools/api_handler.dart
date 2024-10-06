import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class ApiHandler {

  static final String _url = Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';

  /// Checks if the user is in session.
  static Future<bool> userInSession(String token) async {
    final response = await http.get(Uri.parse('$_url/api/user/insession'), headers: {
      "Authorization" : "Bearer $token"
    });
    return jsonDecode(response.body);
  }

  /// Gets the user.
  static Future<Map<String,Object>> getUser(String token) async {
    final response = await http.get(Uri.parse('$_url/api/user'), headers: {
      "Authorization" : "Bearer $token"
    });
    return jsonDecode(response.body);
  }

  /// Logs in the user.
  static Future<String> login(String email, String password) async {
    final response = await http.post(Uri.parse('$_url/api/user/login'), body: {
      'email': email,
      'password': password
    });
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return "";
    }
  }

  /// Registers the user.
  static Future<bool> register(String email, String password, String confirmPassword, String username) async {
    final response = await http.post(Uri.parse('$_url/api/user/register'), body: {
      'email': email,
      'password': password,
      'confirmPassword': confirmPassword,
      'username': username
    });
    return jsonDecode(response.body);
  }

  /// Logs out the user.
  static Future<bool> logout() async {
    final response = await http.post(Uri.parse('$_url/api/user/logout'));
    return jsonDecode(response.body);
  }

  static Future<bool> usernameExists(String username) async {
    final response = await http.get(Uri.parse('$_url/api/user/usernameexists/$username'));
    return jsonDecode(response.body);
  }
}