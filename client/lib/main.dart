import 'package:client/app.dart';
import 'package:client/app_settings.dart';
import 'package:client/screens/login.dart';
import 'package:client/tools/user.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:client/tools/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final user = await User.create();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) =>
              RouterState(path: "", screen: const LoginScreen()),
        ),
        ChangeNotifierProvider.value(
          value: user,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _initializeApp(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        return Builder(
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
        );
      },
    );
  }

  Future<void> _initializeApp(BuildContext context) async {
    final router = Provider.of<RouterState>(context, listen: false);
    final user = Provider.of<User>(context, listen: false);

    AppSettings.initiateScreens(router);

    if (await user.inSession()) {
      router.setPath(context, "home");
    } else {
      router.setPath(context, "");
    }
  }
}
