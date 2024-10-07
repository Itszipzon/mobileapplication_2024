import 'package:client/app.dart';
import 'package:client/screens/login.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              RouterState(path: "", screen: const LoginScreen()),
        ),
        ChangeNotifierProvider(
          create: (context) => User(),
        ),
      ],
      child: Builder(
        builder: (context) {
          final router = Provider.of<RouterState>(context, listen: false);
          final user = Provider.of<User>(context, listen: false);
          return RouterProvider(
            router: router,
            child: UserProvider(
              user: user,
              child: const App(),
            ),
          );
        },
      ),
    ),
  );
}
