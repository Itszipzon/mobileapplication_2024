import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// A class that holds the user's token.
class User extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  User() {
    _loadToken();
  }

  /// Clears the token.
  void clear() {
    _token = null;
    _saveToken();
    notifyListeners();
  }

  /// Sets the token.
  void setToken(String token) {
    _token = token;
    _saveToken();
    notifyListeners();
  }

  /// Returns the authorization header.
  String getAuthorizationHeader() {
    return 'Bearer $_token';
  }

  Future<bool> inSession() async {
    if (_token == null || _token!.isEmpty) {
      return false;
    }

    final response =
        await http.get(Uri.parse('http://localhost:8080/api/user/insession'));
    bool json = jsonDecode(response.body);
    if (!json) {
      clear();
    }
    return json;
  }

  Future<void> _saveToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', _token ?? '');
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('user_token');
    notifyListeners();
  }
}
