import 'package:client/elements/button.dart';
import 'package:client/elements/input.dart';
import 'package:client/tools/router_provider.dart';
import 'package:flutter/material.dart';

class PathSearch extends StatelessWidget {
  const PathSearch({super.key});

  @override
  Widget build(BuildContext context) {

    final pathController = TextEditingController();
    final router = RouterProvider.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Search for a path',
                style: TextStyle(fontSize: 24),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Input(labelText: "Path", controller: pathController, onReturn: (String path) {
                      router.setPath(context, path);
                    }),
                  ),
                  BigIconButton(icon: Icons.search, onPressed: () {
                    router.setPath(context, pathController.text);
                  })
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}