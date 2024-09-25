import 'package:flutter/widgets.dart';

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
}