import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

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
  static Future<Map<String,Object>> getUser(String? token) async {
    if (token == null) {
      return {};
    }
    final response = await http.get(Uri.parse('$_url/api/user'), headers: {
      "Authorization" : "Bearer $token"
    });
    return jsonDecode(response.body);
  }

  /// Logs in the user.
  static Future<Response> login(String email, String password) async {
    final response = await http.post(Uri.parse('$_url/api/user/login'), headers: {
      'Content-Type': 'application/json'
    }, body: jsonEncode({
      'user': email,
      'password': password
    }));
    return response;
  }

  /// Registers the user.
  static Future<Response> register(String email, String password, String confirmPassword, String username, bool terms) async {
    final response = await http.post(
      Uri.parse('$_url/api/user/register'),
      headers: {
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        'email': email,
        'password': password,
        'confirmPassword': confirmPassword,
        'username': username,
        'terms': terms
      }),
    );
    return response;
  }

  /// Logs out the user.
  static Future<bool> logout(String? token) async {
    if (token == null) {
      return false;
    }
    final response = await http.post(Uri.parse('$_url/api/user/logout'), headers: 
      {
        "Authorization" : "Bearer $token"
      });
    return jsonDecode(response.body);
  }

  static Future<bool> usernameExists(String username) async {
    final response = await http.get(Uri.parse('$_url/api/user/usernameexists/$username'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(Uri.parse('$_url/api/user'), headers: {
      "Authorization" : "Bearer $token"
    });
    return jsonDecode(response.body);
  }

    /// Fetches quizzes from the API.
  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    final response = await http.get(Uri.parse('$_url/api/quiz'));

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }


  static Future<http.Response> createQuiz(Map<String, dynamic> quizData) async {
    final response = await http.post(
      Uri.parse('$_url/api/quiz'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_AUTH_TOKEN', // Replace with actual token handling
      },
      body: jsonEncode(quizData),
    );
    return response;
  }
}