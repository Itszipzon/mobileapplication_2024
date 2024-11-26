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

  static String get wsUrl => _wsUrl;


  ///////////////////////////////////////////////////////////////////////
  ///
  
  /// Updates the user's email
  static Future<void> updateEmail(String token, String newEmail) async {
  final response = await http.put(
    Uri.parse('$_url/api/user/update-email'),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "newEmail": newEmail,
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      jsonDecode(response.body)['message'] ?? 'Failed to update email',
    );
  }
}





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

  static Future<List<Map<String, dynamic>>> getQuizzesByCategory(
      String category, int page) async {
    final response =
        await http.get(Uri.parse('$_url/api/quiz/category/$category/$page'));

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

  static Future<Map<String, dynamic>> checkQuiz(String token, Map<String, dynamic> quiz) async {
    final uri = Uri.parse('$_url/api/quiz/game/solo/check');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(quiz),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check quiz answers');
    }
  }

  // Modify ApiHandler.playQuiz
  static Future<Map<String, dynamic>> playQuiz(
      String token, Map<String, dynamic> quiz) async {
    final uri = Uri.parse('$_url/api/quiz/game/solo');

    final response = await http.post(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json'
      },
      body: jsonEncode(quiz),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to check quiz answers');
    }
  }

  /// Fetches the 10 most popular quizzes based on the number of attempts.
  static Future<List<Map<String, dynamic>>> getMostPopularQuizzes(
      int page) async {
    final uri = Uri.parse('$_url/api/quiz/popular/$page');

    final response = await http.get(uri, headers: {
      'Content-Type': 'application/json',
    });

    if (response.statusCode == 200) {
      List<dynamic> quizzes = jsonDecode(response.body);
      return quizzes.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to fetch popular quizzes');
    }
  }

  /// Get list of friends
  static Future<List<Map<String, dynamic>>> getFriends(String token) async {
    final response = await http.get(
      Uri.parse('$_url/api/friends'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> friends = jsonDecode(response.body);
      return friends.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load friends');
    }
  }

  /// Get pending friend requests
  static Future<List<Map<String, dynamic>>> getPendingFriendRequests(
      String token) async {
    final response = await http.get(
      Uri.parse('$_url/api/friends/pending'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode == 200) {
      List<dynamic> requests = jsonDecode(response.body);
      return requests.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load friend requests');
    }
  }

  /// Send friend request
  static Future<void> sendFriendRequest(String token, String username) async {
    final response = await http.post(
      Uri.parse('$_url/api/friends/request/$username'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      String errorMessage = response.body;
      if (response.statusCode == 400) {
        // Handle specific error cases
        switch (errorMessage) {
          case "Cannot send friend request to yourself":
            throw Exception("You can't send a friend request to yourself");
          case "Friend request already exists":
            throw Exception("Friend request already exists");
          default:
            throw Exception(errorMessage);
        }
      } else if (response.statusCode == 404) {
        throw Exception("User not found");
      } else {
        throw Exception("Failed to send friend request");
      }
    }
  }

  /// Accept friend request
  static Future<void> acceptFriendRequest(
      String token, int friendRequestId) async {
    final response = await http.post(
      Uri.parse('$_url/api/friends/accept/$friendRequestId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw Exception("Friend request not found");
      } else {
        throw Exception("Failed to accept friend request");
      }
    }
  }

  /// Remove friend
  static Future<void> removeFriend(String token, String username) async {
    final response = await http.delete(
      Uri.parse('$_url/api/friends/$username'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (response.statusCode == 404) {
        throw Exception("Friendship not found");
      } else {
        throw Exception("Failed to remove friend");
      }
    }
  }

  /// Example usage of the friends list
  /// This shows the structure of the data you'll get back
  static Map<String, dynamic> _parseFriendData(Map<String, dynamic> data) {
    return {
      'friendId': data['friendId'] as int,
      'username': data['username'] as String,
      'status': data['status'] as String,
      'createdAt': data['createdAt'] as String,
      'acceptedAt': data['acceptedAt'] as String?,
      'lastLoggedIn': data['lastLoggedIn'] as String?,
      'profilePicture': data['profilePicture'] as String?,
    };
  }

  static Future<int> getCategoryQuizCount(String categoryName) async {
    final response = await http.get(
      Uri.parse('$_url/api/quiz/category/count/$categoryName'),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to get category quiz count');
  }

  static Future<void> deleteQuiz(String token, int quizId) async {
    final response = await http.delete(
      Uri.parse('$_url/api/quiz/$quizId'),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      switch (response.statusCode) {
        case 401:
          throw Exception("Unauthorized access");
        case 403:
          throw Exception("You don't have permission to delete this quiz");
        case 404:
          throw Exception("Quiz not found");
        default:
          throw Exception("Failed to delete quiz: ${response.body}");
      }
    }
  }

  static Future<void> requestPasswordReset(String email) async {
    final response = await http.post(
      Uri.parse('$_url/api/user/resetpassword'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(email),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to request password reset");
    }
  }

  static Future<void> verifyToken(String email, String token) async {
  final response = await http.post(
    Uri.parse('$_url/api/user/verify-reset-token'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'token': token}),
  );

  if (response.statusCode != 200) {
    throw Exception(jsonDecode(response.body)['message'] ??
        'Failed to verify the reset token.');
  }
}

static Future<void> resetPassword(String token, String newPassword) async {
    final response = await http.post(
      Uri.parse("$_url/api/user/newpassword"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "token": token,
        "newPassword": newPassword,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }


static Future<void> updateUser(
  String token, {
  String? newEmail,
  String? newUsername,
  String? oldPassword,
  String? newPassword,
}) async {
  final response = await http.put(
    Uri.parse('$_url/api/user/update'),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({
      "email": newEmail ?? "",
      "username": newUsername ?? "",
      "oldPassword": oldPassword ?? "",
      "newPassword": newPassword ?? "",
    }),
  );

  if (response.statusCode != 200) {
    throw Exception(
      jsonDecode(response.body)['message'] ?? 'Failed to update user',
    );
  }
}



}


