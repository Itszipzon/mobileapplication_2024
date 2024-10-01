import 'package:client/elements/bottom_navbar.dart';
import 'package:client/tools/router.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key, required this.router});

  final RouterState router;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text("Profile"),
      ),
      bottomNavigationBar: BottomNavbar(path: "profile", router: router),
    );
  }
}