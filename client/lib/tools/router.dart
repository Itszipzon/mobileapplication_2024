import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:client/tools/error_message.dart';
import 'package:client/screens/login.dart';

class RouterState {
  final String path;
  final Map<String, dynamic>? pathVariables;
  final Map<String, dynamic>? values;
  final Map<String, dynamic>? prevValues;
  final List<String> paths;

  RouterState({
    required this.path,
    this.pathVariables,
    this.paths = const [],
    this.values,
    this.prevValues,
  });

  RouterState copyWith({String? path, Map<String, dynamic>? pathVariables, List<String>? paths, Map<String, dynamic>? values, Map<String, dynamic>? prevValues}) {
    return RouterState(
      path: path ?? this.path,
      pathVariables: pathVariables ?? this.pathVariables,
      paths: paths ?? this.paths,
      values: values,
      prevValues: prevValues,
    );
  }
}

class RouterNotifier extends StateNotifier<RouterState> {
  final Map<String, Widget> _screens = {};
  final Set<String> excludedPaths = {};

  RouterNotifier() : super(RouterState(path: ''));

  Widget get currentScreen => _screens[state.path] ?? const LoginScreen();

  void addScreen(String name, Widget screen) {
    _screens[name] = screen;
  }

  void removeScreen(String name) {
    _screens.remove(name);
  }

  void setPath(BuildContext context, String path, {Map<String, dynamic>? values}) {
    final screenName = _getScreenName(path);

    if (!_screens.containsKey(screenName)) {
      ErrorHandler.showOverlayError(context, 'Screen $screenName not found.');
      return;
    }

    final newPathVariables = _extractPathVariables(path);
    final newPaths = List<String>.from(state.paths)..add(screenName);
    final newValues = values ?? {};

    state = state.copyWith(
      path: screenName,
      pathVariables: newPathVariables,
      paths: newPaths,
      prevValues: state.values,
      values: newValues,
    );
  }

  void goBack(BuildContext context) {
    if (state.paths.length > 1) {
      final newPaths = List<String>.from(state.paths)..removeLast();
      state = state.copyWith(path: newPaths.last, paths: newPaths, values: state.prevValues);
    } else {
      ErrorHandler.showOverlayError(context, 'No previous path found.');
    }
  }

  String _getScreenName(String path) {
    return path.contains("?") ? path.split("?")[0] : path;
  }

  Map<String, dynamic>? _extractPathVariables(String path) {
    if (!path.contains("?")) return null;

    final variables = <String, dynamic>{};
    final params = path.split("?")[1].split("&");

    for (var param in params) {
      final pair = param.split("=");
      if (pair.length == 2) {
        variables[pair[0]] = pair[1];
      }
    }

    return variables;
  }

  void excludePath(String path) {
    excludedPaths.add(path);
  }

  void excludePaths(List<String> paths) {
    excludedPaths.addAll(paths);
  }

  Map<String, dynamic>? get getPathVariables => state.pathVariables;

  Map<String, dynamic>? get getValues => state.values;
}

final routerProvider = StateNotifierProvider<RouterNotifier, RouterState>((ref) {
  return RouterNotifier();
});
