import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

/// A class that holds the user's token.
class User extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  /// Clears the token.
  void clear() {
    _token = null;
    notifyListeners();
  }

  /// Sets the token.
  void setToken(String token) {
    _token = token;
    notifyListeners();
  }

  /// Returns the authorization header.
  String getAuthorizationHeader() {
    return 'Bearer $_token';
  }

  Future<bool> inSession() async {

    if (_token == null) {
      return false;
    }

    if (_token!.isEmpty) {
      return false;
    }
    
    final response = await http.get(Uri.parse('http://localhost:8080/api/user/insession'));
    bool json = jsonDecode(response.body);
    return json;
  }
}