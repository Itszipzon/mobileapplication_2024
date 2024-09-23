import 'package:client/screens/login.dart';
import 'package:flutter/material.dart';

class Router {
  Router({required this.path, required this.screen});

  String path;
  Widget screen;

  late Map<String, Widget> screens = {path: screen};
  late Map<String, Object>? values;
  late List<String> paths = [];

  void addScreen(String name, Widget screen) {
    screens[name] = screen;
  }

  Widget getScreen() {
    return screens[path] ?? LoginScreen(switchScreen: switchScreen);
  }

  void setPath(String newPath) {
    path = newPath;
  }

  Widget switchScreen(BuildContext context, String screenName) {
    if (!screens.containsKey(screenName)) {
      showOverlayError(context, 'Screen $screenName not found.');
      return getScreen();
    }

    setPath(getScreenName());
    setValues();
    addToPaths(path);
    return getScreen();
  }

  String getScreenName() {
    if (path.contains("?")) {
      return path.split("?")[0];
    } else {
      return path;
    }
  }

  void setValues() {
    values = {};
    if (path.contains("?")) {
      List<String> value = path.split("?");
      value = value[1].split("&");
      for (int i = 0; i < value.length; i++) {
        values![value[i].split("=")[0]] = value[i];
      }
    }
  }

  void clearValues() {
    values = null;
  }

  void clearScreens() {
    screens = {};
  }

  void clearPaths() {
    paths = [];
  }

  void addToPaths(String newPath) {
    if (paths.contains(newPath)) {
      int index = paths.indexOf(newPath);
      paths = paths.sublist(0, index + 1);
    } else {
      paths.add(newPath);
    }
  }

  Map<String, Object>? getValues() {
    return values;
  }

  List<String> getPaths() {
    return paths;
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
