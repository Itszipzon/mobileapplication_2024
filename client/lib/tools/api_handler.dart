import 'dart:convert';
import 'dart:io';
import 'package:client/dummy_data.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

class ApiHandler {
  //////////////////////////Remote rune//////////////////////////////////

/*   
  static final String _url = "http://10.24.37.76:8080";

  static String get url => _url; */

  //////////////////////////local//////////////////////////////////

  static final String _url =
      Platform.isAndroid ? 'http://10.0.2.2:8080' : 'http://localhost:8080';

  static final String _wsUrl =
      Platform.isAndroid ? 'ws://10.0.2.2:8080' : 'ws://localhost:8080';

  static String get url => _url;

  static String get wsUrl => _wsUrl; */

  ///////////////////////////////////////////////////////////////////////

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
  static Future<Response> login(
      String email, String password, bool rememberMe) async {
    final response = await http.post(Uri.parse('$_url/api/user/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
            {'user': email, 'password': password, 'rememberMe': rememberMe}));
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

  static Future<List<Map<String, dynamic>>> getUserQuizzesByToken(
      String token, int page, int amount) async {
    final response = await http.get(
        Uri.parse('$_url/api/quiz/user/self/$page/$amount'),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<List<Map<String, dynamic>>> getUserQuizzesByUsername(
      String username, int page, int amount) async {
    final response = await http
        .get(Uri.parse('$_url/api/quiz/user/username/$username/$page/$amount'));

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<List<Map<String, dynamic>>> getQuizzesByUserHistory(
      String token, int page, int amount) async {
    final response = await http.get(
        Uri.parse('$_url/api/quiz/user/history/$page/$amount'),
        headers: {"Authorization": "Bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
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

  static Future<List<Map<String, dynamic>>> getQuizzesByFilter(
      int page, int size, String by, String orientation) async {
    final response = await http.get(
        Uri.parse("$_url/api/quiz/all/filter/$page/$size/$by/$orientation"));

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
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

  static Future<List<String>> getQuizCategories() async {
    final response = await http.get(Uri.parse('$_url/api/quiz/categories'));
    return jsonDecode(response.body).cast<String>();
  }

  static Future<List<Map<String, dynamic>>> getQuizzesByCategory(String category, int page) async {
    final response = await http.get(Uri.parse('$_url/api/quiz/category/$category/$page'));
    
    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load quizzes');
    }
  }

  static Future<Map<String, dynamic>> getQuiz(int id) async {
    final response = await http.get(Uri.parse('$_url/api/quiz/$id'));
    return jsonDecode(response.body);
  }

  // Modify ApiHandler.playQuiz
  static Future<Map<String, dynamic>> playQuiz(
      String token, int quizId, List<Map<String, int?>> quizAnswers) async {
    final uri = Uri.parse('$_url/api/quiz/check-answers');
    final payload = {
      "token": token,
      "quizId": quizId,
      "quizAnswers": quizAnswers,
    };

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check quiz answers');
    }
  }
}
