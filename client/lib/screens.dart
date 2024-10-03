import 'package:client/screens/categories.dart';
import 'package:client/screens/home.dart';
import 'package:client/screens/profile.dart';
import 'package:client/screens/register.dart';
import 'package:client/tools/router.dart';

class Screens {
  
  void initiateScreens(RouterState router) {
    router.addScreen("register", const Register());
    router.addScreen("home", Home());
    router.addScreen("categories", const Categories());
    router.addScreen("profile", const Profile());

    router.addExcludedPaths(["", "register", "test"]);
  }

}