import 'dart:convert';

import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Test extends StatefulWidget {

  const Test({super.key});

  @override
  State<StatefulWidget> createState() {
    return TestScreenState();
  }
}

class TestScreenState extends State<Test> {

  String message = "";

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    bool android = true;
    http.Response response;

    try {
      if (android) {
        response = await http.get(Uri.parse('http://10.0.2.2:8080/test/map'));
      } else {
        response = await http.get(Uri.parse('http://localhost:8080/test/map'));
      }

      if (response.statusCode == 200) {
        var r = jsonDecode(response.body);
        setState(() {
          message = r['id'];
        });
      } else {
        setState(() {
          message = 'Failed to load message';
        });
      }
    } catch (e) {
      setState(() {
        print('Error: $e');
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
      
    final router = RouterProvider.of(context);
  
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(router.getValues()!["id"].toString()),
            Text(router.getPathVariables()!["id"].toString()),
            Text(message),
          ],
        ),
      ),
    );
  }
}