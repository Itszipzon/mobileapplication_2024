import 'package:client/dummy_data.dart';
import 'package:client/elements/bottom_navbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          children: [
            Row(
              children: [
                ClipOval(
                  child: Image(
                    image: NetworkImage(DummyData.profilePicture),
                    width: 79,
                    height: 79,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text("Jan Nordskog"), Text("@19232")],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Row(
              children: [],
            )
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavbar(path: "profile"),
    );
  }
}
