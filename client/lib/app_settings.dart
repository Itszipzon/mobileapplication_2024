import 'package:client/screens/categories.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/profile.dart';
import 'package:client/screens/register.dart';
import 'package:client/screens/test.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds all the settings for the application.
class AppSettings {
  
  /// Initiates all the screens in the application.
  static void initiateScreens(RouterState router) {
    router.addScreen("register", const Register());
    router.addScreen("home", Home());
    router.addScreen("categories", const Categories());
    router.addScreen("profile", const Profile());
    router.addScreen('test', const Test());

    router.addExcludedPaths(["", "register", "test"]);
  }

  /// Returns the theme for the application.
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Colors.orange,
      canvasColor: const Color.fromARGB(255, 241, 241, 241),
      useMaterial3: true,
      textTheme: GoogleFonts.robotoTextTheme(),
    );
  }
}
