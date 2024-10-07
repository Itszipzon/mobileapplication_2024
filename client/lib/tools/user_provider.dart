import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';

class UserProvider extends InheritedWidget {
  final User user;

  const UserProvider({
    super.key,
    required super.child,
    required this.user,
  });

  static User of(BuildContext context) {
    final UserProvider? provider =
        context.dependOnInheritedWidgetOfExactType<UserProvider>();
    assert(provider != null, 'No RouterProvider found in context');
    return provider!.user;
  }
  
  @override
  bool updateShouldNotify(UserProvider oldWidget) {
    return user != oldWidget;
  }
}