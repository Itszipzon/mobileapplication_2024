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
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _router = RouterProvider.of(context);
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      theme: AppSettings.getTheme(),
      home: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _router.setPath(context, "path_search");
            },
          ),
          title: const Image(image: AssetImage("assets/logo.png"), height: 30),
        ),
        body: Container(
          decoration: BoxDecoration(
            color: theme.canvasColor,
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
