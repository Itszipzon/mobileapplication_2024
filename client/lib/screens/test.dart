import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {

  const Test({super.key});

  @override
  State<StatefulWidget> createState() {
    return TestScreenState();
  }
}

class TestScreenState extends State<Test> {
  
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
            ],
          ),
        ),
      );
    }
}