import 'dart:convert';
import 'dart:io';
import 'package:client/elements/button.dart';
import 'package:client/tools/router.dart';
import 'package:client/tools/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class Test extends ConsumerStatefulWidget {
  const Test({super.key});

  @override
  ConsumerState<Test> createState() => TestScreenState();
}

class TestScreenState extends ConsumerState<Test> {
  String httpId = "";
  late UserNotifier user;

  @override
  void initState() {
    super.initState();
    fetchMessage();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    user = ref.read(userProvider.notifier);
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
    final router = ref.read(routerProvider.notifier);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(router.getValues!["id"].toString()),
            Text(router.getPathVariables!["id"].toString()),
            Text(httpId),
            BigIconButton(
              icon: Icons.person,
              height: 56,
              width: 56,
              onPressed: () {
              user.clearToken();
            }),
          ],
        ),
      ),
    );
  }
}
