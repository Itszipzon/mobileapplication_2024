import 'package:client/tools/api_handler.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User extends ChangeNotifier {
  String? _token;

  static Future<User> create() async {
    final user = User._();
    await user._loadToken();
    return user;
  }

  User._();

  void clear() {
    _token = null;
    _saveToken();
    notifyListeners();
  }

  void setToken(String token) {
    _token = token;
    _saveToken();
    notifyListeners();
  }

  String getToken() {
    return _token ?? '';
  }

  String getAuthorizationHeader() {
    return _token != null ? 'Bearer $_token' : '';
  }

  Future<bool> inSession() async {
    if (_token == null) return false;
    final bool result = await ApiHandler.userInSession(_token!);
    if (!result) clear();
    return result;
  }

  Future<bool> logout() async {
    final bool result = await ApiHandler.logout(_token);
    if (result) clear();
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

  Future<Map<String, dynamic>> getProfile() async {
    return await ApiHandler.getProfile(_token!);
  }
}
