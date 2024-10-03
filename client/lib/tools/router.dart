import 'package:client/screens/login.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/screens.dart';
import 'package:flutter/material.dart';

/// Holds all pages in the application and handles values needed for the pages.
class RouterState extends ChangeNotifier {
static RouterState? _instance;

  late String path;
  late Widget screen;
  late Map<String, Object>? values;
  late Map<String, Widget> screens = {path: screen};
  late Map<String, Object>? pathVariables = {};
  late List<String> paths = [];
  Set<String> excludedPaths = {}; 

  RouterState._internal({required this.path, required this.screen, this.values}) {
    initiateScreens();
  }

  /// Returns the instance of the [RouterState] class.
  factory RouterState({required String path, required Widget screen, Map<String, Object>? values}) {
    _instance ??= RouterState._internal(path: path, screen: screen, values: values);
    return _instance!;
  }

  void initiateScreens() {
    Screens().initiateScreens(this);
  }

  void setValues(Map<String, Object> newValues) {
    values = newValues;
  }

  Map<String, Object>? getValues() {
    return values;
  }

  void setPath(String newPath) {
    path = newPath;
  }

  void addScreen(String name, Widget screen) {
    screens[name] = screen;
  }

  Widget getScreen() {
    return screens[path] ?? Container();
  }

  void removeScreen(String name) {
    screens.remove(name);
  }

  void clearScreens() {
    screens = {};
  }

  void clearPaths() {
    paths = [];
  }

  void clearPathVariables() {
    pathVariables = {};
  }

  void clearValues() {
    values = {};
  }

  /// Clears all values and paths.
  void clearAll() {
    clearPathVariables();
    clearValues();
  }

  ErrorHandler error = ErrorHandler();

  /// Switches to a new screen.
  Widget switchScreen(BuildContext context, String screenName) {
    if (!screens.containsKey(_getScreenName(screenName))) {
      error.showOverlayError(context, 'Screen $_getScreenName(screenName) not found.');
      return screens[path] ?? const LoginScreen();
    }
    clearAll();
    setPathVariables(screenName);
    addPath(_getScreenName(screenName));
    setPath(_getScreenName(screenName));
    notifyListeners();
    return getScreen();
  }

  /// Switches to a new screen with values.
  Widget switchScreenWithValue(BuildContext context, String screenName, Map<String, Object>? values) {
    if (!screens.containsKey(_getScreenName(screenName))) {
      error.showOverlayError(context, 'Screen $_getScreenName(screenName) not found.');
      return screens[path] ?? const LoginScreen();
    }
    clearAll();
    setValues(values!);
    setPathVariables(screenName);
    addPath(_getScreenName(screenName));
    setPath(_getScreenName(screenName));
    notifyListeners();
    return getScreen();
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
  void setPathVariables(String path) {
    pathVariables = {};

    if (path.contains("?")) {
      List<String> value = path.split("?");
      value = value[1].split("&");

      for (int i = 0; i < value.length; i++) {
        pathVariables![value[i].split("=")[0]] = value[i].split("=")[1];
      }

    }

  }

  Map<String, Object>? getPathVariables() {
    return pathVariables;
  }

  /// Adds a path to the path list.
  void addPath(String path) {

    if (excludedPaths.contains(path)) {
      return;
    }

    if (paths.contains(path)) {
      int index = paths.indexOf(path);
      paths = paths.sublist(0, index + 1);
    } else {
      paths.add(path);
    }
    notifyListeners();
  }

  /// Adds a new excluded path to the list.
  void addExcludedPath(String path) {
    excludedPaths.add(path);
  }

  /// Adds a list of excluded paths to the list.
  void addExcludedPaths(List<String> paths) {
    excludedPaths.addAll(paths);
  }

  /// Removes an excluded path from the list.
  void removeExcludedPath(String path) {
    excludedPaths.remove(path);
  }

  int _getPathsLength() {
    return paths.length;
  }

  /// Returns the previous screen.
  Widget back() {
    if (paths.length > 1) {
      paths.removeLast();
      setPath(paths.last);
      return getScreen();
    } else {
      return getScreen();
    }
  }

}
