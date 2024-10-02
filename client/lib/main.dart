import 'package:client/app.dart';
import 'package:client/tools/User.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

final theme = ThemeData(
  primaryColor: Colors.orange,
  useMaterial3: true,
  textTheme: GoogleFonts.robotoTextTheme(),
);

void main() {
  runApp(MaterialApp(
      theme: theme,
      home: ChangeNotifierProvider(
    create: (context) => User(),
    child: const App(),
  )));
}
