import 'dart:convert';
import 'dart:io';

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
  String httpId = "";

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  Future<void> fetchMessage() async {
    http.Response response;

    try {
      String url;
      if (Platform.isAndroid) {
        url = 'http://10.0.2.2:8080/test/map';
      } else {
        url = 'http://localhost:8080/test/map';
      }

      response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var r = jsonDecode(response.body);
        setState(() {
          httpId = r['id'];
        });
      } else {
        setState(() {
          httpId = 'Failed to load message';
        });
      }
    } catch (e) {
      setState(() {
        httpId = 'Failed to load message';
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
            Text(httpId),
          ],
        ),
      ),
    );
  }
}
