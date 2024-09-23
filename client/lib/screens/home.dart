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
            ElevatedButton(
              onPressed: () {
                switchScreen(context, 'login');
              },
              child: const Text('Login'),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                switchScreen(context, 'register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}