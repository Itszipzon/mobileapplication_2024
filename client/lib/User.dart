import 'package:flutter/widgets.dart';

class User extends ChangeNotifier {
  String? _token;

  String? get token => _token;

  void clear() {
    _token = null;
    notifyListeners();
  }
}