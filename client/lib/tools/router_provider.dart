/* import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class RouterProvider extends InheritedWidget {
  final RouterState router;

  const RouterProvider({
    super.key,
    required super.child,
    required this.router,
  });

  static RouterState of(BuildContext context) {
    final RouterProvider? provider =
        context.dependOnInheritedWidgetOfExactType<RouterProvider>();
    assert(provider != null, 'No RouterProvider found in context');
    return provider!.router;
  }

  @override
  bool updateShouldNotify(RouterProvider oldWidget) {
    return router != oldWidget.router;
  }
}
 */