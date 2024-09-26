import 'package:client/screens/categories.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/profile.dart';
import 'package:client/screens/register.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {

    late final RouterState _router;

  void initiateScreens() {
    _router.addScreen("register", Register(switchScreen: switchScreen));
    _router.addScreen("home", Home(switchScreen: switchScreen));
    _router.addScreen("categories", Categories(switchScreen: switchScreen));
    _router.addScreen("profile", Profile(switchScreen: switchScreen));

    _router.addExcludedPaths(["", "register", "test"]);
  }

  @override
  void initState() {
    super.initState();
    _router = RouterState(path: 'login', screen: LoginScreen(switchScreen: switchScreen));
    initiateScreens();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 241, 241, 241),
          ),
          child: _router.getScreen(),
        ),
      ),
    );
  }

  void switchScreen(BuildContext context, String path) {
    setState(() {
      _router.switchScreen(context, path);
    });
  }

  void switchScreenWithValue(BuildContext context, String path, Map<String, Object> values) {
    setState(() {
      _router.switchScreenWithValue(context, path, values);
    });
  }
}
