import 'package:client/tools/router.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    print("didChangeDependencies");
    _router = RouterProvider.of(context);
  }

  @override
  Widget build(BuildContext context) {

    // The theme of the application.
    final theme = ThemeData(
      primaryColor: Colors.orange,
      useMaterial3: true,
      textTheme: GoogleFonts.robotoTextTheme(),
    );

    return MaterialApp(
      theme: theme,
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
