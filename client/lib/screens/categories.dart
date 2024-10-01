import 'package:client/elements/bottom_navbar.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  const Categories({super.key, required this.router});

  final RouterState router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Categories"),
      ),
      bottomNavigationBar: BottomNavbar(path: "categories", router: router),
    );
  }
  
}