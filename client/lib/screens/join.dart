import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter/material.dart';

class Join extends StatelessWidget {
  const Join({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Join"),
      ),
      bottomNavigationBar: BottomNavbar(path: "join"),
    );
  }
}
