import 'package:client/screens/categories.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/join.dart';
import 'package:client/screens/login.dart';
import 'package:client/screens/path_search.dart';
import 'package:client/screens/profile.dart';
import 'package:client/screens/quiz/create_quiz.dart';
import 'package:client/screens/quiz/quiz.dart';
import 'package:client/screens/quiz/quiz_lobby.dart';
import 'package:client/screens/register.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Holds all the settings for the application.
class AppSettings {
  
  /// Initiates all the screens in the application.
  static void initiateScreens(RouterNotifier router) {
    router.addScreen("", const LoginScreen());
    router.addScreen("register", const Register());
    router.addScreen("home", const Home());
    router.addScreen("categories", const Categories());
    router.addScreen("join", const Join());
    router.addScreen('path_search', const PathSearch());
    router.addScreen("profile", const Profile());
    router.addScreen("create", const CreateQuiz());
    router.addScreen("quiz", const QuizScreen());
    router.addScreen("quiz/lobby", const QuizLobby());

    router.excludePaths(["", "register", "test"]);
  }

  /// Returns the theme for the application.
  static ThemeData getTheme() {
    return ThemeData(
      primaryColor: Colors.orange,
      canvasColor: const Color.fromARGB(255, 241, 241, 241),
      scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 241),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(255, 241, 241, 241),
      ),
      textTheme: GoogleFonts.robotoTextTheme(),
    );
  }
}
