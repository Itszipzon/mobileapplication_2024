import 'package:client/screens/login.dart';
import 'package:client/tools/error_message.dart';
import 'package:flutter/material.dart';

class RouterState extends ChangeNotifier {
  static RouterState? _instance;

  late String _path;
  late Widget _screen;
  late Map<String, Object>? _values;
  late Map<String, Widget> _screens = {_path: _screen};
  late Map<String, Object>? _pathVariables = {};
  late List<String> _paths = [];
  Set<String> excludedPaths = {};

  RouterState._internal(
      {required String path,
      required Widget screen,
      Map<String, Object>? values}) {
    _path = path;
    _screen = screen;
    _values = values;
  }

  /// Returns the instance of the [RouterState] class.
  factory RouterState(
      {required String path,
      required Widget screen,
      Map<String, Object>? values}) {
    _instance ??=
        RouterState._internal(path: path, screen: screen, values: values);
    return _instance!;
  }

  Map<String, Object>? getValues() {
    return _values;
  }

  /// Sets a new path linked to a screen.
  void setPath(BuildContext context, String path,
      {Map<String, Object>? values}) {
    if (!_screens.containsKey(_getScreenName(path))) {
      ErrorHandler.showOverlayError(
          context, 'Screen ${_getScreenName(path)} not found.');
      return;
    }
    clear();
    _path = _getScreenName(path);
    addPath(_getScreenName(path));
    _values = values;
    _setPathVariables(path);
    notifyListeners();
  }

  void addScreen(String name, Widget screen) {
    _screens[name] = screen;
  }

  Widget getScreen() {
    return _screens[_path] ?? const LoginScreen();
  }

  void removeScreen(String name) {
    _screens.remove(name);
  }

  void clearScreens() {
    _screens = {};
  }

  void clearPaths() {
    _paths = [];
  }

  void clearPathVariables() {
    _pathVariables = {};
  }

  void clearValues() {
    _values = {};
  }

  /// Returns the path variables.
  Map<String, Object>? getPathVariables() {
    return _pathVariables;
  }

  void clear() {
    _values = {};
    _pathVariables = {};
  }

  /// Returns the name of the screen without the path variables.
  String _getScreenName(String path) {
    if (path.contains("?")) {
      return path.split("?")[0];
    } else {
      return path;
    }
  }

  /// Sets the path variables.
  void _setPathVariables(String path) {
    _pathVariables = {};

    if (path.contains("?")) {
      List<String> value = path.split("?");
      value = value[1].split("&");

      for (int i = 0; i < value.length; i++) {
        _pathVariables![value[i].split("=")[0]] = value[i].split("=")[1];
      }
    }
  }

  void addExcludedPaths(List<String> paths) {
    excludedPaths.addAll(paths);
  }

  void addExcludedPath(String path) {
    excludedPaths.add(path);
  }

  int getPathsLength() {
    return _paths.length;
  }

  /// Adds a path to the path list.
  void addPath(String path) {
    if (excludedPaths.contains(path)) {
      return;
    }

    if (_paths.contains(path)) {
      int index = _paths.indexOf(path);
      _paths = _paths.sublist(0, index + 1);
    } else {
      _paths.add(path);
    }
    notifyListeners();
  }

  void goBack(BuildContext context) {
    if (_paths.length > 1) {
      _paths.removeLast();
      setPath(context, _paths.last);
    } else {
      ErrorHandler.showOverlayError(context, 'No previous path found.');
    }
  }
}
