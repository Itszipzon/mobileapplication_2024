import 'package:client/App.dart';
import 'package:client/User.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => User(),
    child: const App(),
  ));
}
