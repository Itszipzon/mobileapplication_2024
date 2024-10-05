import 'package:client/app_settings.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late RouterState _router;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _router = RouterProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppSettings.getTheme(),
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 241, 241, 241),
          ),
          child: Consumer<RouterState>(
            builder: (context, router, child) {
              return _router.getScreen();
            },
          ),
        ),
      ),
    );
  }
}