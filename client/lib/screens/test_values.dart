import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TestPage extends StatefulWidget {
  final Function(BuildContext, String) switchScreen;
  final RouterState router;

  const TestPage({required this.switchScreen, super.key, required this.router});

  @override
  TestPageState createState() => TestPageState();
}

class TestPageState extends State<TestPage> {

  late String message = "Loading...";

  Future<void> fetchMessage() async {
    final response = await http.get(Uri.parse("http://localhost:8080/test")).catchError((error) {
      print(error.toString());
      return http.Response('Error', 500);
    });
    print(response.body);
    print(response.statusCode);
  }

  @override
  initState() {
    super.initState();
    fetchMessage().then((value) {
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Values: $message'),
            ElevatedButton(
              onPressed: () {
                widget.switchScreen(context, 'home');
              },
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}