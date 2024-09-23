import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TestValues extends StatelessWidget {

  TestValues({
      super.key,
      required this.switchScreen,
      this.values,
    }) {
      if (values != null && values!['message'] != null) {
        message = values!['message'] as String;
      }
    }

  final Function(BuildContext, String) switchScreen;
  final Map<String, Object>? values;

  late String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'testValues',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 24),
              Text('Values: $message'),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  switchScreen(context, 'login');
                },
                child: const Text('Go to login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}