import 'package:client/screens/home.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/register.dart';
import 'package:client/screens/test_values.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
/*   late final custom_router.Router _router = custom_router.Router(
      path: "login", screen: LoginScreen(switchScreen: switchScreen)); */

    late final RouterState _router;

  void initiateScreens() {
    _router.addScreen("", LoginScreen(switchScreen: switchScreen));
    _router.addScreen("register", Register(switchScreen: switchScreen));
    _router.addScreen("home", Home(switchScreen: switchScreen));
    _router.addScreen("test", TestPage(switchScreen: switchScreen, router: _router));

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
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 78, 13, 151),
                Color.fromARGB(255, 107, 15, 168),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: _router.getScreen(),
        ),
      ),
    );
  }

  void switchScreen(BuildContext context, String screenName) {
    setState(() {
      _router.switchScreen(context, screenName);
    });
  }
}
