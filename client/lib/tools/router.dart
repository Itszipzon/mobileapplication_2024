import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';

class RouterState {
  static RouterState? _instance;

  late String path;
  late Widget screen;
  late Map<String, Object>? values;

  RouterState._internal({required this.path, required this.screen, this.values});

  factory RouterState({required String path, required Widget screen, Map<String, Object>? values}) {
    _instance ??= RouterState._internal(path: path, screen: screen, values: values);
    return _instance!;
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

  late Map<String, Widget> screens = {path: screen};
  late Map<String, Object>? pathVariables = {};
  late List<String> paths = [];

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

  void clearAll() {
    clearScreens();
    clearPaths();
    clearPathVariables();
    clearValues();
  }

  Widget switchScreen(BuildContext context, String screenName) {
    if (!screens.containsKey(getScreenName(screenName))) {
      showOverlayError(context, 'Screen $getScreenName(screenName) not found.');
      return screens[path] ?? LoginScreen(switchScreen: switchScreen);
    }
    clearAll();
    setPathVariables(screenName);
    addPath(getScreenName(screenName));
    setPath(getScreenName(screenName));
    return getScreen();
  }

  Widget switchScreenWithValue(BuildContext context, String screenName, Map<String, Object>? values) {
    if (!screens.containsKey(getScreenName(screenName))) {
      showOverlayError(context, 'Screen $getScreenName(screenName) not found.');
      return screens[path] ?? LoginScreen(switchScreen: switchScreen);
    }
    clearAll();
    setValues(values!);
    setPathVariables(screenName);
    addPath(getScreenName(screenName));
    setPath(getScreenName(screenName));
    return getScreen();
  }

  String getScreenName(String path) {
    if (path.contains("?")) {
      return path.split("?")[0];
    } else {
      return path;
    }
  }

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

  void addPath(String path) {
    if (paths.contains(path)) {
      int index = paths.indexOf(path);
      paths = paths.sublist(0, index + 1);
    } else {
      paths.add(path);
    }
  }

  int getPathsLength() {
    return paths.length;
  }

  Widget back() {
    if (paths.length > 1) {
      paths.removeLast();
      setPath(paths.last);
      return getScreen();
    } else {
      return getScreen();
    }
  }

  void showOverlayError(BuildContext context, String errorMessage) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 0,
        right: 0,
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.redAccent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }
}
