import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  
  const TestPage({super.key, required this.switchScreen, this.values,});

  final Function(BuildContext, String) switchScreen;
  final Map<String, Object>? values;

  @override
  TestPageState createState() => TestPageState();
}

// ignore: must_be_immutable
class TestPageState extends State<TestPage> {
  late String message = '';

  @override
  void initState() {
    super.initState();
    message = widget.values!['message'].toString();
  }

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
                  widget.switchScreen(context, 'login');
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
