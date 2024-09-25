import 'package:client/elements/small_button.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.switchScreen});

  final Function(BuildContext, String) switchScreen;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SmallTextButton(text: "Login", onPressed: () {
              switchScreen(context, 'login');
            }),

            const SizedBox(height: 24),

            SmallTextButton(text: "Register", onPressed: () {
              switchScreen(context, 'register');
            }),
          ],
        ),
      ),
    );
  }
}