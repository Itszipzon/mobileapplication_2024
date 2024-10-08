import 'package:client/tools/api_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A class that holds the user's token.
class User extends ChangeNotifier {
  String? _token;

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

  String getToken() {
    if (_token == null) {
      return '';
    }
    return _token!;
  }

  /// Returns the authorization header.
  String getAuthorizationHeader() {
    if (_token == null) {
      return '';
    }
    return 'Bearer $_token';
  }

  Future<bool> inSession() async {
    if (_token == null) {
      return false;
    }
    final bool result = await ApiHandler.userInSession(_token!);
    if (!result) {
      clear();
    }
    return result;
  }

  Future<bool> logout() async {
    final bool result = await ApiHandler.logout(_token);
    if (result) {
      clear();
    }
    return result;
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
