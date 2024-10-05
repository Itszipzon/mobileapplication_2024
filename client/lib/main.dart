import 'package:client/main_app.dart';
import 'package:client/screens/login.dart';
import 'package:client/tools/User.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (context) => RouterState(path: "", screen: const LoginScreen()),
      child: ChangeNotifierProvider(
        create: (context) => User(),
        child: Builder(
          builder: (context) {
            final router = Provider.of<RouterState>(context, listen: false);
            return RouterProvider(
              router: router,
              child: const App(),
            );
          },
        ),
      ),
    ),
  );
}
