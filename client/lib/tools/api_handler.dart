import 'dart:convert';
import 'dart:io';
import 'package:client/dummy_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class ApiHandler {
  static final String _url =
      Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';

  static String get url => _url;

  /// Checks if the user is in session.
  static Future<bool> userInSession(String token) async {
    final response = await http.get(Uri.parse('$_url/api/user/insession'),
        headers: {"Authorization": "Bearer $token"});
    return jsonDecode(response.body);
  }

  /// Gets the user.
  static Future<Map<String, Object>> getUser(String? token) async {
    if (token == null) {
      return {};
    }
    final response = await http.get(Uri.parse('$_url/api/user'),
        headers: {"Authorization": "Bearer $token"});
    return jsonDecode(response.body);
  }

  /// Logs in the user.
  static Future<Response> login(String email, String password) async {
    final response = await http.post(Uri.parse('$_url/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': email, 'password': password}));
    return response;
  }

  /// Registers the user.
  static Future<Response> register(String email, String password,
      String confirmPassword, String username, bool terms) async {
    final response = await http.post(
      Uri.parse('$_url/api/user/register'),
      headers: {"Content-Type": "application/json"},
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
    final response = await http.post(Uri.parse('$_url/api/user/logout'),
        headers: {"Authorization": "Bearer $token"});
    return jsonDecode(response.body);
  }

  static Future<bool> usernameExists(String username) async {
    final response =
        await http.get(Uri.parse('$_url/api/user/usernameexists/$username'));
    return jsonDecode(response.body);
  }

  static Future<bool> hasPfp(String username) async {
    final response =
        await http.get(Uri.parse('$_url/api/user/haspfp/$username'));
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getProfile(String token) async {
    final response = await http.get(Uri.parse('$_url/api/user'),
        headers: {"Authorization": "Bearer $token"});
    return jsonDecode(response.body);
  }

  static Future<String> getProfilePicture(String username) async {
    final response = await ApiHandler.hasPfp(username);
    if (response) {
      return '$_url/api/user/pfp/$username';
    } else {
      return DummyData.profilePicture;
    }
  }

  /// Fetches quizzes from the API.
  static Future<List<Map<String, dynamic>>> getQuizzes() async {
    final response = await http.get(Uri.parse('$_url/api/quiz'));

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      for (var quiz in quizzes) {
        print(quiz["id"]);
      }
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<http.Response> createQuiz(
      Map<String, dynamic> quizData, String token, File thumbnail) async {
    final uri = Uri.parse('$_url/api/quiz');

    String fileExtension = thumbnail.path.split('.').last.toLowerCase();
    String mimeType;
    if (fileExtension == 'png') {
      mimeType = 'image/png';
    } else if (fileExtension == 'jpg' || fileExtension == 'jpeg') {
      mimeType = 'image/jpeg';
    } else {
      throw Exception('Unsupported file type');
    }

    var request = http.MultipartRequest('POST', uri)
      ..headers['Authorization'] = 'Bearer $token'
      ..files.add(http.MultipartFile.fromString(
        'quiz',
        jsonEncode(quizData),
        contentType: MediaType('application', 'json'),
      ))
      ..files.add(await http.MultipartFile.fromPath(
        'thumbnail',
        thumbnail.path,
        contentType: MediaType.parse(mimeType),
      ));

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    
    return response;
  }
}
