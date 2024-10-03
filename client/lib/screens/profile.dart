import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text("Profile"),
      ),
      bottomNavigationBar: BottomNavbar(path: "profile"),
    );
  }
}